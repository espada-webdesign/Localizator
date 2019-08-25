class SearchController < ApplicationController
   LIMIT = 10
   def packetery
     t = params[:term]+'%'
     branches = PacketeryBranch.where('id like ? or street like ? or
city like ? or zip like ?', t, t, t, t).limit(LIMIT)

     render json: branches.map{|c| {id: c.id, street: c.street, city:
c.city, zip: c.zip, title: [c.id,c.street,c.city,c.zip].join(' - ')}}
   end
end
