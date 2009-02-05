# You can also use them in controllers with "include Lister"

ILIKE = UsingPostgres ? 'ilike' : 'like'

module Lister

  def def_sort_rules(*args)
    @sort_rules = {}
    args.each{|k| sort_rule(k)}
    yield if block_given?
  end
  def sort_rule(sort_key,&block)
    if block_given?
      @sort_rules[sort_key] = block
    else
      if sort_key.is_a?(String)
        @sort_rules[sort_key] = Proc.new do |r|
          r && r["#{sort_key}"] ? r["#{sort_key}"].downcase : ""
        end
      else
        @sort_rules[sort_key[0]] = Proc.new do 
          sort_key[1] ? sort_key[1].downcase : ""
        end
      end
    end
  end
  def sort_rule_date(sort_key)
    @sort_rules[sort_key] = Proc.new do |r|
      (r && r[sort_key] && r[sort_key] != '') ? Date.new(*ParseDate.parsedate(r[sort_key])[0..3]) : Date.new
    end
  end
  def apply_sort_rule(r = nil)
    orders = []
    order_current = @search_params[:order_current]
    if order_current
      raise "No sort rule is defined for #{order_current}" if  !@sort_rules[order_current]
      orders << order_current
      order_last = @search_params[:order_last]
      if order_last
        raise "No sort rule is defined for #{order_last}" if order_last && !@sort_rules[order_last]
        orders = orders << order_last
      end
    end
    orders.map{|order| @sort_rules[order].call(r)} 
  end
 
  def def_search_rules(kind,pairs)
    @search_rules ||= {}
    @search_rules['all'] = 'dummy value'
    case kind
    when :sql #The search rules generated here will be used for a call to Rails find.
      pairs.each do |key,field|
        def_search_rule(key+'_b') {|search_for| ["#{field} #{ILIKE} ?",search_for+'%']}
        def_search_rule(key+'_c') {|search_for| ["#{field} #{ILIKE} ?",'%'+search_for+'%']}
        def_search_rule(key+'_is') {|search_for| ["#{field} = ?", search_for]}
        def_search_rule(key+'_not') {|search_for| ["#{field} != ?", search_for]}
      end
#    when :locate #The search rules generated here will be used for a call to Record.locate, via fill_and_locate_records
#      pairs.each do |key,field|
#        def_search_rule(key+'_b') {|search_for| ":#{field} =~ /^#{search_for}/i"}
#        def_search_rule(key+'_c') {|search_for| ":#{field} =~ /#{search_for}/i"}
#        def_search_rule(key+'_is') {|search_for| ":#{field} == '#{search_for}'"}
#        def_search_rule(key+'_not') {|search_for| ":#{field} != '#{search_for}'"}
#      end
#    when :search  #The search rules generated here will be used for a call to Record.search via fill_recs
#      pairs.each do |key,field|
#        def_search_rule(key+'_b') {|search_for| ":#{field} #{ILIKE} '#{search_for}%'"}
#        def_search_rule(key+'_c') {|search_for| ":#{field} #{ILIKE} '%#{search_for}%'"}
#        def_search_rule(key+'_is') {|search_for| ":#{field} = '#{search_for}'"}
#        def_search_rule(key+'_not',:negate=>true) {|search_for| ":#{field} = '#{search_for}'"}
#      end
    end
  end

  def def_search_rule(key,params={},&block)
    @search_rules ||= {}
    @search_rules[key] = {:block => block,:params => params}
  end
    
  def generate_search_options(kind)
    case kind
    when :sql
      apply_search_rules(true)
#    when :locate
#      apply_search_rules(false)
#    when :search
#      options = {}
#      conditions = []
#      meta_conditions = []
#      generate_options do |search_rule,search_for|
#        # searching for something with | in it requires ust to generate the full conditions ored together
#        c = '('+search_for.split(/\W*\|\W*/).collect {|search_for| search_rule[:block].call(search_for)}.join(' or ')+')'
#        c = 'not '+c if search_rule[:params][:negate]
#        search_rule[:params][:meta_condition] ? meta_conditions.push(c) : conditions.push(c)
#      end
#      options[:conditions] = conditions.join(' and ') if !conditions.empty?
#      options[:meta_condition] = meta_conditions.join(' and ') if !meta_conditions.empty?
#      options = nil if options.empty?
#      options
    end
  end
  
  def generate_options
    @search_params.each_pair do |k,v|
      if v == 'all'
        @display_all = true
      elsif k =~ /^on(.*)/ && v && v != ''
        params_key = k
        params_value = v      
        matching_params_key = 'for' + $1 
        raise "No search rule is defined for #{params_value}" if !@search_rules.has_key?(params_value)
        raise "No search value is defined for #{matching_params_key}" if !@search_params.has_key?(matching_params_key)
        if @search_params[matching_params_key] != ''
          yield @search_rules[params_value],@search_params[matching_params_key]
        end
      end
    end
  end
  
  def apply_search_rules(sql)
    @filters ||= []
    generate_options do |search_rule,search_for|
      search_for = Regexp.escape(search_for).gsub('/','\/') unless sql
      search_for = search_for.split(/\\\||\|/)
      queries = []
      terms = [] if sql
      search_for.map!{|s| search_rule[:block].call(s)}.each do |s|
        if sql
          queries << s[0]
          terms << s[1]
        else
          queries << s
        end
      end
      if sql 
        search_for = ["(#{queries.join(' or ')})",terms]
      else
        search_for = queries.join(' || ')
      end
      @filters << search_for
    end
    if sql #Combine filters in format sql likes
      conditions = []
      sql_terms = []
      @filters.each do |f|
        sql_terms << f[0]
        conditions = conditions + f[1]
      end
      sql_terms = sql_terms << @search_params[:sql] if (@search_params[:sql] && @search_params[:sql] != '')
      @filters = [sql_terms.join(" and ")] + conditions if (sql_terms != [] || conditions != [])
    end
    @filters = nil if @filters.empty? 
    @filters
  end
  
  def field_blank_sql(field)
    "(:#{field} = '' or :#{field} is null)"
  end
  
  def set_params(listing_type,use_session,defaults={})  
    if !params[:search] 
      # if the search params aren't in the actual params from the request
      # then you can look for them in the session, if that's what the page would like
      if use_session
        @search_params = session[listing_type]
      end
    else
      @search_params = params[:search].update({:page => params[:page]})
    end
    @search_params ||= {}
    @search_params[:order_last] = session[listing_type][:order_current] if session[listing_type] && session[listing_type].key?(:order_current)  
    #grab order param from session for secondary sort, if it's nontrivial and not the current order
    defaults.each do |param,default|
      if (!use_session || param = :order_current) && (!@search_params.key?(param) || @search_params[param] == '')
        @search_params[param] = default
      end
    end
    @search_params.each_pair do |k,v| 
      if k =~ /^on(.*)/ && (!v || v == '')
        matching_params_key = 'for' + $1 
        @search_params[matching_params_key] = ''
      end
    end
    session[listing_type] = @search_params #Store in session in case needed later
  end

  def get_sql_options
    options = {}
    options[:order] = apply_sort_rule.join(",")
    options[:conditions] = generate_search_options(:sql)
    options
  end
  
  def get_search_form_html(order_choices,form_pair_info,select_options = nil,allow_manual_filters = false)
    form_pairs_html = []
    form_pair_info.each do |pair|
      first_focus = pair[:first_focus] ? {:class => 'first_focus'} : {}
      this_html = pair[:label] ? pair[:label] : ''
      this_html << 
        case pair[:on]
        when :select
          select_tag("search[on_#{pair[:name]}]", options_for_select(select_options[pair[:name]],@search_params["on_#{pair[:name]}"])) 
        when :text_field
          text_field_tag("search[on_#{pair[:name]}]", @search_params["on_#{pair[:name]}"])
        when :hidden
          hidden_field(:search, "on_#{pair[:name]}", :value => pair[:value])
        else
          ''
        end
      this_html <<
        case pair[:for]
        when :select
          select_tag("search[for_#{pair[:name]}]", options_for_select(select_options[pair[:name]],@search_params["for_#{pair[:name]}"]),first_focus) 
        when :text_field
          val = ''
          val = @search_params["for_#{pair[:name]}"] if !['all','',nil].include?(@search_params["on_#{pair[:name]}"]) 
          text_field_tag("search[for_#{pair[:name]}]", val,first_focus)
        when :hidden
          hidden_field(:search, "for_#{pair[:name]}", :value => pair[:value])
        else
          ''
        end
      this_html << text_field_tag("search[sql]", @search_params[:sql]) if pair[:sql]
      form_pairs_html << this_html
    end
  	order_select = "Order by:  " + select_tag('search[order_current]', options_for_select(order_choices,@search_params[:order_current]))
  	mf = %Q|<p>Manual filters: #{ text_field_tag('search[manual_filters]', @search_params[:manual_filters], :size=>60)}</p>| if allow_manual_filters
    
    html =<<-EOHTML
    <fieldset class='search_box'><legend>Search</legend><p>#{form_pairs_html.join("</p><p>")}</p>
      <p>#{order_select}</p>#{mf}
      <p>#{check_box_tag('search[paginate]','yes',@search_params[:paginate]=='yes')} Paginate results
        <input id='search[paginate]' name='search[paginate]' type='hidden' value='no' />
      </p>
      <p><input type='submit' name='Submit' value='Search'></p>
    </fieldset>
    EOHTML
  end
end
