require_relative '../db/config'
require_relative 'models/legislator'
require 'awesome_print'

# ALL_STATES = [”AK”,”AL”,”AR”,”AS”,”AZ”,”CA”,”CO”,”CT”,”DE”,”FL”,”GA”,”GU”,”HI”,”IA”,”ID”,
# “IL”,”IN”,”KS”,”KY”,”LA”,”MA”,”MD”,”ME”,”MH”,”MI”,”MN”,”MO”,”MS”,”MT”,”NC”,”ND”,”NE”,”NH”,”NJ”,”NM”,”NV”,”NY”,
# “OH”,”OK”,”OR”,”PA”,”RI”,”SC”,”SD”,”TN”,”TX”,”UT”,”VA”,”VI”,”VT”,”WA”,”WI”,”WV”,”WY”]

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

ap Legislator.count(:conditions => ["title = ?", "Rep"])

# ap Legislator.where("state = ? AND title = ?", "CA", "Sen")
# p Legislator.where("title = ?")


# print_legislators("CA")
# print_gender_stats("F")



