def pdb(thing = '', backtrace_offset: 0, production: false, **keywords)
  return if Rails.env.production? && !production

  backtrace_line = caller[backtrace_offset].split(':')[0..1].join(':')
  thing = keywords if thing.blank? && keywords.any?
  thing = thing.inspect unless thing.is_a?(String)

  puts(
    (
      'PDB' + ': ' + thing
    ).colorize(color: :black, background: :light_white) +
      " @ #{backtrace_line}".colorize(color: :blue, background: :light_white)

  )
  puts "\n"
  thing
end

def pdbp(*args, **keywords)
  pdb(*args, **keywords.merge(production: true, backtrace_offset: 1))
end
