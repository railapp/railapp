# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2005-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
#
# Migration project helper to provide syntactic sugar.
##

require 'yaml'

module ActiveRecord

 class Migration

  Datatypes = YAML.load "
   chat: varchar(255)
   email: varchar(240)
   id: int(11) unsigned
   phone: varchar(40)
   salt: char(8)
   string: varchar(255)
   sha1: char(40) 
   tweet: varchar(140)
   uri: varchar(255)
  "

  Expansions = YAML.load "
   arrival: arrival datetime, index(arrival),
   born: born datetime, index(born),
   departure: departure datetime, index(departure),
   died: died datetime, index(died),
   eta: eta datetime, index(eta),
   hexcolor: hexcolor char(6), index(hexcolor),
   id: id int(11) unsigned not null auto_increment primary key,
   latitude: latitude float, index(latitude),
   lock: lock_version int(11) unsigned default 0, index(lock_version),
   longitude: longitude float, index(longitude),
   position: position int unsigned default 0, index(position),
   priority: priority int unsigned default 0, index(priority),
   name: name tinytext, index(name),
   note: note longtext,
   status: status int unsigned default 0, index(status),
   tags: tags longtext default "",
   timestamps: created_at datetime, index(created_at), updated_at datetime, index(updated_at),
   userstamps: created_by int(11), index(created_by), updated_by int(11), index(updated_by),
   height: height float, index(height),
   weight: weight float, index(weight),
  "

  DatatypesRegex = Datatypes.keys.join('|')
  ExpansionsRegex = Expansions.keys.join('|')

  def self.to_mysql(rsql)
   r=rsql.clone
   r.gsub!(/^( *)(add )?(\w+)_id (id )?references /)              {"#{$1}#{$2}#{$3}_id id, references "}
   r.gsub!(/^( *)(add )?(\w+)( .+), references /)                 {"#{$1}#{$2}#{$3}#{$4}, #{$2}index(#{$3}), #{$2}foreign key(#{$3}) references "}
   r.gsub!(/^( *)(add )?(\w+)( .+) index(,?) *$/)                 {"#{$1}#{$2}#{$3}#{$4}, #{$2}index(#{$3})#{$5}"}
   r.gsub!(/^( *)(create table\s+)(\w+.*?)\n(.*?)(\n\s+\n|\Z)/m)  {table=$3; return "#{$1}#{$2}#{$3}(\n#{$4}#{$5}\n#{$1});"}
   r.gsub!(/^( *)(alter table\s+)(\w+.*?)\n(.*?)(\n\s+\n|\Z)/m)   {table=$3; "#{$1}#{$2}#{$3}\n#{$4}#{$5}\n#{$1};"}
   r.gsub!(/^( *)parent,(\s*?)$/)                                 {"#{$1}parent_id int(11), index(parent_id), foreign key(parent_id) references {#table}(id)#{$3}"}
   r.gsub!(/^( *)(#{ExpansionsRegex}),(\s*?)$/)                   {"#{$1}#{Expansions[$2]}#{$3}"}
   r.gsub!(/(\w+) (#{DatatypesRegex})\b/)                         {"#{$1} #{Datatypes[$2]}"}
   puts "-- rsql in " + rsql + "\n-- rsql out " + r
   r.gsub!(/\s*\n\s*/m,' ')
   r.strip!
   execute r
  end

 end
end
