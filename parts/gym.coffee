if Meteor.isClient
    Router.route '/gym', (->
        @layout 'layout'
        @render 'gym'
        ), name:'gym'
    
    
    Template.gym.onCreated ->
        # @autorun => Meteor.subscribe 'doc_comments', @data._id, ->


    Template.gym.helpers
        checkin_sessions: ->
            Meteor.users.find 
                gym_checkedin:true
                
    Template.gym.events
        'click .self_checkin': ->
            if confirm 'checkin?'
                Meteor.users.update Meteor.userId(),
                    $set:gym_checkedin:true

        'click .unpublish': ->
            Swal.fire({
                title: "unpublish thing?"
                text: "point bounty will be returned to your account"
                icon: 'question'
                confirmButtonText: 'unpublish'
                confirmButtonColor: 'orange'
                showCancelButton: true
                cancelButtonText: 'cancel'
                reverseButtons: true
            }).then((result)=>
                if result.value
                    Meteor.call 'unpublish_thing', @_id, =>
                        Swal.fire(
                            position: 'bottom-end',
                            icon: 'success',
                            title: 'thing unpublished',
                            showConfirmButton: false,
                            timer: 1000
                        )
            )
            
            