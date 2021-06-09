if Meteor.isClient
    Router.route '/posts', (->
        @layout 'layout'
        @render 'posts'
        ), name:'posts'
    Router.route '/user/:username/posts', (->
        @layout 'user_layout'
        @render 'user_posts'
        ), name:'user_posts'
    Router.route '/post/:doc_id', (->
        @layout 'layout'
        @render 'post_view'
        ), name:'post_view'
    Router.route '/post/:doc_id/view', (->
        @layout 'layout'
        @render 'post_view'
        ), name:'post_view_long'
    
    
    Template.posts.onCreated ->
        @autorun => Meteor.subscribe 'post', ->
            
            
#     Template.product_posts.onCreated ->
#         @autorun => Meteor.subscribe 'product_posts', Router.current().params.doc_id, ->
#     Template.user_posts.onCreated ->
#         @autorun => Meteor.subscribe 'user_sent_posts', Router.current().params.username, ->
#         @autorun => Meteor.subscribe 'user_received_posts', Router.current().params.username, ->
            
#     Template.post_edit.onCreated ->
#         @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
#     Template.post_view.onCreated ->
#         @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
    

#     Template.post_view.helpers
#         is_cook: -> Meteor.userId() in @cook_ids
#         is_fav: -> Meteor.userId() in @favorite_user_ids
#     Template.post_view.events
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

    Template.posts.events
        'click .add_post': ->
            new_id = Docs.insert 
                model:'post'
            Router.go "/post/#{new_id}/edit"    
    
#     Template.product_posts.events
#         'click .add_post': ->
#             new_id = Docs.insert 
#                 model:'post'
#                 product_id:Router.current().params.doc_id
#             Router.go "/post/#{new_id}/edit"    
                
#     Template.user_posts.events
#         'click .send_post': ->
#             new_id = 
#                 Docs.insert 
#                     model:'post'
            
#             Router.go "/post/#{new_id}/edit"
            
            
#         # 'click .edit_address': ->
#         #     Session.set('editing_id',@_id)
#         # 'click .remove_address': ->
#         #     if confirm 'confirm delete?'
#         #         Docs.remove @_id
#         # 'click .add_address': ->
#         #     new_id = 
#         #         Docs.insert
#         #             model:'address'
#         #     Session.set('editing_id',new_id)
            
           
           
            
#     Template.user_posts.helpers
#         sent_posts: ()->
#             Docs.find   
#                 model:'post'
#                 _author_username:Router.current().params.username
#         received_posts: ()->
#             Docs.find   
#                 model:'post'
#                 recipient_username:Router.current().params.username
        
# if Meteor.isServer
#     Meteor.publish 'user_received_posts', (username)->
#         Docs.find   
#             model:'post'
#             recipient_username:username
            
            
#     Meteor.publish 'user_sent_posts', (username)->
#         Docs.find   
#             model:'post'
#             _author_username:username
#     Meteor.publish 'product_posts', (product_id)->
#         Docs.find   
#             model:'post'
#             product_id:product_id
            
            
            
            
if Meteor.isClient
    Router.route '/post/:doc_id/edit', (->
        @layout 'layout'
        @render 'post_edit'
        ), name:'post_edit'



    Template.post_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'menu_section'


    Template.post_edit.events
        'click .send_post': ->
            Swal.fire({
                title: 'confirm send card'
                text: "#{@amount} credits"
                icon: 'question'
                showCancelButton: true,
                confirmButtonText: 'confirm'
                cancelButtonText: 'cancel'
            }).then((result) =>
                if result.value
                    post = Docs.findOne Router.current().params.doc_id
                    Meteor.users.update Meteor.userId(),
                        $inc:credit:-@amount
                    Docs.update post._id,
                        $set:
                            sent:true
                            sent_timestamp:Date.now()
                    Swal.fire(
                        'post sent',
                        ''
                        'success'
                    Router.go "/post/#{@_id}/"
                    )
            )

        'click .delete_post':->
            if confirm 'delete?'
                Docs.remove @_id
                Router.go "/posts"
            
    Template.post_edit.helpers
        all_shop: ->
            Docs.find
                model:'post'