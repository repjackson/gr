# if Meteor.isClient
#     Router.route '/services', (->
#         @layout 'layout'
#         @render 'services'
#         ), name:'services'
#     Router.route '/user/:username/services', (->
#         @layout 'user_layout'
#         @render 'user_services'
#         ), name:'user_services'
#     Router.route '/service/:doc_id', (->
#         @layout 'layout'
#         @render 'service_view'
#         ), name:'service_view'
#     Router.route '/service/:doc_id/view', (->
#         @layout 'layout'
#         @render 'service_view'
#         ), name:'service_view_long'
#     Router.route '/product/:doc_id/services', (->
#         @layout 'product_layout'
#         @render 'product_services'
#         ), name:'product_services'
    
    
#     Template.services.onCreated ->
#         @autorun => Meteor.subscribe 'model_docs', 'service', ->
            
            
#     Template.service_edit.onCreated ->
#         @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
#     Template.service_view.onCreated ->
#         @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
    

#     Template.service_view.helpers
#         is_cook: -> Meteor.userId() in @cook_ids
#         is_fav: -> Meteor.userId() in @favorite_user_ids
#     Template.service_view.events
#         'click .mark_cook': ->
#             Docs.update Router.current().params.doc_id, 
#                 $addToSet: cook_ids:Meteor.userId()
#             $('body').toast(
#                 showIcon: 'food'
#                 message: "marked cooked"
#                 showProgress: 'bottom'
#                 class: 'success'
#                 # displayTime: 'auto',
#                 position: "bottom right"
#             )
#         'click .unmark_cook': ->
#             Docs.update Router.current().params.doc_id, 
#                 $pull: cook_ids:Meteor.userId()
       
#         'click .mark_fav': ->
#             Docs.update Router.current().params.doc_id, 
#                 $addToSet: favorite_user_ids:Meteor.userId()
#             $('body').toast(
#                 showIcon: 'heart'
#                 message: "marked favorite"
#                 showProgress: 'bottom'
#                 class: 'error'
#                 # displayTime: 'auto',
#                 position: "bottom right"
#             )
#         'click .unmark_fav': ->
#             Docs.update Router.current().params.doc_id, 
#                 $pull: favorite_user_ids:Meteor.userId()

#     Template.services.events
#         'click .add_service': ->
#             new_id = Docs.insert 
#                 model:'service'
#             Router.go "/service/#{new_id}/edit"    
    
        
# if Meteor.isServer
#     Meteor.publish 'user_received_services', (username)->
#         Docs.find   
#             model:'service'
#             recipient_username:username
            
            
#     Meteor.publish 'user_sent_services', (username)->
#         Docs.find   
#             model:'service'
#             _author_username:username
#     Meteor.publish 'product_services', (product_id)->
#         Docs.find   
#             model:'service'
#             product_id:product_id
            
            
            
            
# if Meteor.isClient
#     Router.route '/service/:doc_id/edit', (->
#         @layout 'layout'
#         @render 'service_edit'
#         ), name:'service_edit'



#     Template.service_edit.onCreated ->
#         @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
#         # @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
#         # @autorun => Meteor.subscribe 'model_docs', 'menu_section'


#     Template.service_edit.events
#         'click .send_service': ->
#             Swal.fire({
#                 title: 'confirm send card'
#                 text: "#{@amount} credits"
#                 icon: 'question'
#                 showCancelButton: true,
#                 confirmButtonText: 'confirm'
#                 cancelButtonText: 'cancel'
#             }).then((result) =>
#                 if result.value
#                     service = Docs.findOne Router.current().params.doc_id
#                     Meteor.users.update Meteor.userId(),
#                         $inc:credit:-@amount
#                     Docs.update service._id,
#                         $set:
#                             sent:true
#                             sent_timestamp:Date.now()
#                     Swal.fire(
#                         'service sent',
#                         ''
#                         'success'
#                     Router.go "/service/#{@_id}/"
#                     )
#             )

#         'click .delete_service':->
#             if confirm 'delete?'
#                 Docs.remove @_id
#                 Router.go "/services"
            
#     Template.service_edit.helpers
#         all_shop: ->
#             Docs.find
#                 model:'service'