desc "fetch lists from catalog and save to cache"
task :fetch_lists => :environment do

    require 'mechanize'
    require 'open-uri'
    require 'memcachier'
    require 'dalli'

    books_fic     = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    books_nonfic  = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    teen_books    = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    teen_manga    = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    youth_books   = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    youth_display = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    dvds_hot      = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)
    dvds_new      = JSON.parse(open("http://kcl-listcacher.herokuapp.com/list/fetch.json?list_id=20518").read)


    Rails.cache.write("books_fic", books_fic)
    Rails.cache.write("books_nonfic", books_nonfic)
    Rails.cache.write("teen_books", teen_books)
    Rails.cache.write("teen_manga", teen_manga)
    Rails.cache.write("youth_books", youth_books)
    Rails.cache.write("youth_display", youth_display)
    Rails.cache.write("dvds_hot", dvds_hot)
    Rails.cache.write("dvds_new", dvds_new)

end
