#
# Show PPMC mentors
#

class PPMCMentors < Vue
  def initialize
    @ipmc = []
  end

  def render
    _h2.mentors! 'Mentors'
    _table.table.table_hover do
      _thead do
        _tr do
          _th if @@auth.ipmc
          _th 'id'
          _th 'public name'
          _th 'notes'
        end
      end

      _tbody do
        roster.each do |person|
          _PPMCMentor auth: @@auth, person: person, ppmc: @@ppmc
        end
      end
    end
  end

  # compute roster
  def roster
    result = []
    
    @@ppmc.mentors.each do |id|
      person = @@ppmc.roster[id]
      person.id = id
      result << person
    end

    result.sort_by {|person| person.name}
  end
end

#
# Show a mentor of the PPMC
#

class PPMCMentor < Vue
  def render
    _tr do

      if @@auth.ipmc
        _td do
           _input type: 'checkbox', checked: @@person.selected || false,
             onChange: -> {self.toggleSelect(@@person)}
        end
      end

      if @@person.member
        _td { _b { _a @@person.id, href: "committer/#{@@person.id}" } }
        _td { _b @@person.name }
      elsif @@person.name
        _td { _a @@person.id, href: "committer/#{@@person.id}" }
        _td @@person.name
      else
        _td @@person.id
        _td @@person.name
      end
        
      _td data_ids: @@person.id do
        if @@person.selected
          if @@auth.ppmc
            unless @@ppmc.owners.include? @@person.id
              _button.btn.btn_primary 'Add to the PPMC',
                data_action: 'add ppmc committer',
                data_target: '#confirm', data_toggle: 'modal',
                data_confirmation: "Add #{@@person.name} as member of the " +
                  "#{@@ppmc.display_name} PPMC?"
            end
          end
        elsif not @@person.name
          _span.issue 'invalid user'
        elsif not @@ppmc.owners.include? @@person.id
          _span.issue 'not on the PPMC'
        elsif not @@person.ipmc
          _span.issue 'not on the IPMC'
        elsif not @@person.icommit
          _span.issue 'not listed as an incubator committer'
        end
      end
    end
  end

  # toggle checkbox
  def toggleSelect(person)
    person.selected = !person.selected
    @@ppmc.refresh()
  end
end
