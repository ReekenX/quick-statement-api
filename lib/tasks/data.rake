namespace :data do
  desc 'Export database to JSON'
  task :export => :environment do
    # Export mockups
    filepath = File.join(Rails.root, 'tmp', 'mockups.json')
    mockups = Mockup.all.as_json
    File.open(filepath, 'w') do |f|
      f.write(JSON.pretty_generate(mockups))
    end
    puts "Exported #{mockups.size} mockups to #{filepath}"

    # Export categories
    filepath = File.join(Rails.root, 'tmp', 'categories.json')
    categories = Category.all.as_json
    File.open(filepath, 'w') do |f|
      f.write(JSON.pretty_generate(categories))
    end
    puts "Exported #{categories.size} categories to #{filepath}"
  end

  desc 'Import database from JSON'
  task :import => :environment do
    # Import categories
    filepath = File.join('tmp', 'categories.json')
    abort "Input file not found: #{filepath}" unless File.exist?(filepath)
    imported_count = 0
    categories = JSON.parse(File.read(filepath))
    categories.each do |category|
      if Category.where(slug: category['slug']).exists?
        Category.find_by(slug: category['slug']).update_attributes!(category.except('id'))
      else
        Category.create!(category)
        imported_count += 1
      end
    end
    puts "Imported #{imported_count} out of #{categories.size} categories"

    # Import mockups
    filepath = File.join('tmp', 'mockups.json')
    abort "Input file not found: #{filepath}" unless File.exist?(filepath)
    imported_count = 0
    mockups = JSON.parse(File.read(filepath))
    mockups.each do |mockup|
      if Mockup.where(photo_filename: mockup['photo_filename']).exists?
        Mockup.find_by(photo_filename: mockup['photo_filename']).update_attributes!(mockup.except('id'))
      else
        Mockup.create!(mockup)
        imported_count += 1
      end
    end
    puts "Imported #{imported_count} out of #{mockups.size} mockups"
  end
end
