# collins-vagrant

### A demo vagrant for [Tumblr's Collins](http://tumblr.github.io/collins/), an infrastructure management app.

---

# Requirements
:warning: vagrant-berkshelf has been deprecated, so that dependency should 
be eliminated at some point.

* VirtualBox
* Berkshelf `gem install berkshelf`
* Vagrant
  * vagrant-berkshelf `vagrant plugin install vagrant-berkshelf`
  * vagrant-omnibus `vagrant plugin install vagrant-omnibus`

# Usage
* `vagrant up`
* Navigate to: [http://localhost:9000](http://localhost:9000)

# Credentials
* User: blake
* Password: admin:first

See [the quickstart documentation](http://tumblr.github.io/collins/#quickstart) for more detail on the defaults.

# Attributes
In general, you shouldn't have to mess with these. 

# Author
Author:: Bill West (<william.a.west@gmail.com>)
