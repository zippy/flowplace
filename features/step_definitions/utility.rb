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

def count_table_rows(count)
  within('table') do |scope|
    (rows,cols) = parse_table(scope)
    rows.size.should == count.to_i
  end
end

def examine_table_row_column(should_not,text,index,column_index)
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

Then /^I should see a table with ([0-9]+) rows$/ do |count|
  count_table_rows(count)
end

Then /^I should see a table with ([0-9]+) rows within "([^\"]*)"$/ do |count,selector|
  within(selector) do |outside|
    count_table_rows(count)
  end
end

Then /^I should( not)* see "(.*)" in row (\d*)( column (\d*))*$/ do |should_not,text,index,dummy,column_index|
  examine_table_row_column(should_not,text,index,column_index)
end

Then /^I should( not)* see "(.*)" in row (\d*)( column (\d*))* within "([^\"]*)"$/ do |should_not,text,index,dummy,column_index,selector|
  within(selector) do |outside|
    examine_table_row_column(should_not,text,index,column_index)
  end
end

Then /^what$/ do
  save_and_open_page
end