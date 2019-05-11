require './config/environment'

begin
  fi_check_migration

  use Rack::MethodOverride
  use ArtistsController
  use GenresController
  use SongsController
  run ApplicationController
  if Artist.all.empty?
    LibraryParser.parse
  end
rescue ActiveRecord::PendingMigrationError => err
  STDERR.puts err
  exit 1
end
