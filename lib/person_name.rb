# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2007-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
# License:: LGPL, GNU Lesser General Public License

module PersonName

  def full_name
    pieces = []
    (pieces << first_name.to_s)     if respond_to?(:first_name) and first_name and first_name.strip!=''
    (pieces << middle_name.to_s)    if respond_to?(:middle_name) and middle_name and middle_name.strip!=''
    (pieces << last_name.to_s)      if respond_to?(:last_name) and last_name and last_name.strip!=''
    return pieces.join(' ')
  end

  def list_name
    pieces = []
    (pieces << last_name.to_s+',')  if respond_to?(:last_name) and last_name and last_name.strip!=''
    (pieces << first_name.to_s)     if respond_to?(:first_name) and first_name and first_name.strip!=''
    (pieces << middle_name.to_s)    if respond_to?(:middle_name) and middle_name and middle_name.strip!=''
    return pieces.join(' ')
  end

  def middle_initial
    return ((respond_to?(:middle_name) and middle_name and middle_name.strip!='') ? middle_name[0] : nil)
  end

end
