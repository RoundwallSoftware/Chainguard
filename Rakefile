task :default => [:mogenerator]

desc "Regenerate mogenerator files."
task :mogenerator do
  exec 'mogenerator --template-var arc=true --template-var frc=true -m Manifest/Model.xcdatamodeld/Model\ 2.xcdatamodel -O Manifest/'
end
