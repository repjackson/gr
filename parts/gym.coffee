if Meteor.isClient
    Router.route '/gym', (->
        @layout 'layout'
        @render 'gym'
        ), name:'gym'
    
    
    Template.gym.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'checkin_session', ->


    Template.gym.helpers
        checkedin_users: ->
            Meteor.users.find 
                gym_checkedin:true
        checkin_sessions: ->
            Docs.find 
                model:'checkin_session'
                # gym_checkedin:true
                
    Template.gym.events
        'click .checkout': ->
            if confirm 'checkout?'
                Meteor.users.update Meteor.userId(),
                    $set:gym_checkedin:false
                checkin_session = 
                    Docs.findOne
                        model:'checkin_session'
                        _author_id:Meteor.userId()
                        status:'checked_in'
                if checkin_session
                    Docs.update checkin_session._id,
                        $set:status:'checked_out'
                    
        'click .self_checkin': ->
            if confirm 'checkin?'
                Meteor.users.update Meteor.userId(),
                    $set:gym_checkedin:true
                Docs.insert 
                    model:'checkin_session'
                    status:'checked_in'
                    checkin_timestamp:Date.now()
                    checkedin_username:Meteor.user().username

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
            
            