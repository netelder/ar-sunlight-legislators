require_relative '../db/config'
require_relative 'models/legislator'
require 'awesome_print'

# the Munger gem looks like it would make this all much easier:
# https://github.com/schacon/munger/wiki/MungerData

ALL_STATES = ["AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"]

def legislators_by_state(state_abbr)
  Legislator.select("firstname, lastname, party, title").where("state = ? AND in_office = ?", state_abbr, 1).order("lastname DESC")
end

def print_legislators(state_abbr)
  legs = legislators_by_state(state_abbr)
  puts "Senators:"
  legs.find_all { | leg | leg.title == "Sen"}.each do |leg|
    puts "  #{leg.firstname} #{leg.lastname} (#{leg.party})"
  end
  puts "Representatives:"
  legs.find_all { | leg | leg.title == "Rep"}.each do |leg|
    puts "  #{leg.firstname} #{leg.lastname} (#{leg.party})"
  end
end

def gender_count(gender, title)
  Legislator.count(:conditions => ["gender = ? AND title = ? AND in_office = ?", gender.upcase, title, 1])
end

def count_by_office(title)
  Legislator.count(:conditions => ["title = ? AND in_office = ?", title, 1])
end

def count_by_office_state(title, state)
  Legislator.count(:conditions => ["title = ? AND in_office = ? AND state = ?", title, 1, state])
end

def print_gender_stats(gender)
  gender == "F" ? gender_string = "Female" : gender_string = "Male"
  reps = gender_count(gender, "Rep")
  sens = gender_count(gender, "Sen")
  total_reps = count_by_office("Rep")
  total_sens = count_by_office("Sen")
  ap "#{gender_string} Senators: #{sens} (#{(100*sens/total_sens)}%)"
  ap "#{gender_string} Representatives: #{reps} (#{(100*reps/total_reps)}%)"
end

def print_leg_count_by_state
  count_by_state = []
  ALL_STATES.each do |state|
    count_by_state << [state, count_by_office_state("Sen", state), count_by_office_state("Rep", state)]
  end
  count_by_state.sort_by { | state | state[1] + state[2]}.reverse_each do |state|
    puts "#{state[0]}: #{state[1]} Senators, #{state[2]} Representatives"
  end
end

def count_by_title(title)
 Legislator.count(:conditions => ["title = ?", title])
end


print_legislators("CA")
puts

print_gender_stats("M")
puts

print_leg_count_by_state
puts

puts "Senators: #{count_by_title("Sen")}"
puts "Representatives: #{count_by_title("Rep")}"

def remove_inactive!
  Legislator.delete_all("in_office = 0")
end
puts

remove_inactive!

puts "Senators: #{count_by_title("Sen")}"
puts "Representatives: #{count_by_title("Rep")}"






