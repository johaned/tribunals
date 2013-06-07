Fog.mock!
connection = Fog::Storage.new(:provider => 'AWS')
connection.directories.create(:key => 'tribunals.cjs.gov.uk')

