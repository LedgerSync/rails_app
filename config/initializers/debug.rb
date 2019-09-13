def pdb_awesome_print?
  @pdb_awesome_print ||= begin
    require 'awesome_print'
    Object.const_defined?('AwesomePrint')
  rescue LoadError
    false
  end
end

def pdb(thing = '', backtrace_offset: 0, production: false, **keywords)
  return if Rails.env.production? && !production

  backtrace_line = caller[backtrace_offset].split(':')[0..1].join(':')
  thing = keywords if thing.blank? && keywords.any?

  if pdb_awesome_print?
    ap thing
    puts "--> @ #{backtrace_line}".colorize(color: :blue, background: :light_white)
    puts "\n"
  else
    thing = thing.inspect unless thing.is_a?(String)
    puts(
      (
        'PDB' + ': ' + thing
      ).colorize(color: :black, background: :light_white) +
        " @ #{backtrace_line}".colorize(color: :blue, background: :light_white)

    )
    puts "\n"
  end
  thing
end

def pdbp(*args, **keywords)
  pdb(*args, **keywords.merge(production: true, backtrace_offset: 1))
end
