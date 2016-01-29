# Creates JSON output with the following format:
#
# {
#   "lastTimestamp": "20160119171152Z", // most recent modifyTimestamp
#   "committees": {
#     "abdera": {
#       "modifyTimestamp": "20111204095436Z",
#       "roster": ["uid",
#       ...
#       ]
#     },
#     ...
#   },
# }
#

require 'bundler/setup'

require_relative 'public_json_common'

require 'whimsy/asf'

ldap = ASF.init_ldap
exit 1 unless ldap

# gather committee info
entries = {}

committees = ASF::Committee.preload # for performance

lastStamp = ''
committees.keys.sort_by {|a| a.name}.each do |entry|
    m = []
    entry.members.sort_by {|a| a.name}.each do |e|
        m << e.name
    end
    lastStamp = entry.modifyTimestamp if entry.modifyTimestamp > lastStamp
    entries[entry.name] = {
        modifyTimestamp: entry.modifyTimestamp,
        roster: m 
    }
end

info = {
  lastTimestamp: lastStamp,
  committees: entries,
}

public_json_output(info)