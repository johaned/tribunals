
def delete_test_files
  ['html', 'pdf'].each do |suffix|
    path = File.join(Rails.root, 'tmp', "test.#{suffix}")
    File.unlink(path) if File.exists? path
  end
end
