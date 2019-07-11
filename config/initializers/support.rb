def support(*paths)
  paths.each do |path|
    require Rails.application.root.join('spec/support/', path.to_s)
  end
end
