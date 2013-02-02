# HashDB

HashDB is a minimal, in-memory, ActiveRecord like database library,
backed by a Ruby Hash.

## Installation

Gem releases are not done frequently as of now. I recommend installing through
the git repository.

Add this line to your application's Gemfile:

    gem 'hash_db', git: "https://github.com/utkarshkukreti/hash_db.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone https://github.com/utkarshkukreti/hash_db.git
    $ cd hash_db
    $ bundle install
    $ rake install

## Quickstart

(Complete usage instructions are below.)

    require 'hash_db'

    class Score
      include HashDB::Model
      keys :name, :points
    end

    score = Score.new name: "A", points: 10
    score.save #= score.id == 1
    Score.create name: "B", points: 11 #= id == 2
    Score.create name: "C", points: 6 #= id == 3

    Score.where(name: "B", points: 11).count #= 1
    Score.where([:points, :>, 4], [:name, :=~, /a|b/i]).count #= 2
    Score.find_by(:points, :>, 8).id #= 1

## Usage

First, require HashDB.

    require 'hash_db'

To make your class a HashDB model, just include `HashDB::Model` module in
your class.

    class Post
      include HashDB::Model
    end

Defining attributes is as easy as calling `keys`, with the key names you want.

      keys :title, :content

HashDB will automatically create getters and setters for these keys, so you can
now assign `title` and `content` to objects of the Post class.

    post = Post.new
    post.title = "Introducing HashDB"
    post.content = "..."

Just as with ActiveRecord, you can also pass a Hash with key/value pairs to .new

    # Same as above
    post = Post.new title: "Introducing HashDB", content: "..."

To be able to query the model, objects must be saved, using `.save`.

    post.save

This saves the object into Class.all Hash, with auto generated `id` key as the
key, and object as the value.

    Post.all == { 1 => post } #= true

Like ActiveRecord, `.new` and `.save` can be combined into just a `.create` call
on the class.

    Post.create title: "Second Post"
    Post.all.count == 2 #= true

## Querying

HashDB currently has just 2 query methods, `.where`, which can filter objects
using key(s) = value(s), and also using custom method call, like `:<` and `:>`.

Let's [HN](http://news.ycombinator.com) as an example. :)

    class Item
      include HashDB::Model
      keys :url, :title, :points, :comment_count
    end

    Item.create url: "http://blog.heroku.com/archives/2011/7/12/matz_joins_heroku/",
                title: "Matz (creator of Ruby) joins Heroku",
                points: 569,
                comment_count: 79
    Item.create url: "http://www.rubymotion.com/",
                title: "RubyMotion - Ruby for iOS",
                points: 466,
                comment_count: 248
    Item.create url: "http://repl.it/",
                title: "Try Python, Ruby, Lua, Scheme, QBasic, Forth...",
                points: 379,
                comment_count: 80

You can query by key = value

    Item.where(points: 569).count #= 1

by key = value pairs

    Item.where(points: 569, comment_count: 79).count #= 1

by custom method call

    Item.where(:points, :>, 400).count #= 2

and by custom method call pairs

    Item.where([:points, :>, 400], [:title, :=~, /ios/i]).count #= 1

## Associations

TODO: Add Documentation

## License

MIT License. (c) 2013 Utkarsh Kukreti.
