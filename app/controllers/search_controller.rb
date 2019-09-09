class SearchController < ApplicationController
   LIMIT = 10
   def show
     t = '%' + params[:term].sub(' ','% %') + '%'
     branches = PsStore.where('name like ? or address1 like ? or
city like ? or postcode like ?', t, t, t, t).limit(LIMIT)
     p branches.map
     render json: branches.map{|c| {name: c.name, address1: c.address1, city:
c.city, postcode: c.postcode, title: [c.name,c.address1,c.city,c.postcode].join(' ')}}
   end
end
