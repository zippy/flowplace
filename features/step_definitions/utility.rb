def parse_table(table_scope)
  table = table_scope.dom.to_s.gsub(/\n/,'')
  table =~ /<table[^>]*>(.*)<\/table>/
  table_contents = $1
  rows = table_contents.scan(/<tr[^>]*>(.*?)<\/tr>/m).collect {|r| r[0]}
  cols = []
  rows.each do |row|
    cols.push row.scan(/<t[dh][^>]*>(.*?)<\/t[dh]>/m).collect {|r| r[0]}
  end
  [rows,cols]
end

Then /^I should see a table with ([0-9]+) rows$/ do |count|
  within('table') do |scope|
    (rows,cols) = parse_table(scope)
    rows.size.should == count.to_i
  end
end

Then /^I should( not)* see "(.*)" in row (\d*)( column (\d*))*$/ do |should_not,text,index,dummy,column_index|
  text = text.gsub('(','\\(')
  text = text.gsub(')','\\)')
  text = text.gsub(']','\\]')
  text = text.gsub('[','\\[')
  within('table') do |scope|
    (rows,cols) = parse_table(scope)
    item = column_index ? cols[index.to_i][column_index.to_i] : rows[index.to_i]
    if should_not
      rows[index.to_i].should_not =~ /#{text}/
    else
      rows[index.to_i].should =~ /#{text}/
    end
  end
end