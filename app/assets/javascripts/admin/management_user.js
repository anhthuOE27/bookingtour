$(document).ready(function() {
  $('body').on('change', "#number_role", function(){
    alert($(this).val());
    var role = $(this).val()
    var user_id  = $(this).attr('data-id')
    // console.log(user_id)
    $.ajax({
      url: '/admin/users/'+role,
      type: 'PATCH',
      data: {role: role, user_id: user_id}
    });
  })

  $('#fullname').keyup(function() {
    var name = $(this).val()
     $.ajax({
      url: '/admin/users/search_user',
      type: 'GET',
      data: {name: name},
      dataType: 'json',
      success: function(result){
        //$("#div1").html(result);
        console.log(result)
        let html = '';
        $.each(result, function(index, val){
          html+=  '<tr>'+
                    '<td>'+
                      check_null(val.id)+
                    '</td>'+
                    '<td>'+
                      check_null(val.fullname)+
                    '</td>'+
                    '<td>'+
                      check_null(val.email)+
                    '</td>'+
                    '<td>'+
                      check_null(val.address)+
                    '</td>'+
                    '<td>'+
                      check_null(val.phone)+
                    '</td>'+
                    '<td>'+
                      '<select id="number_role" data-id='+val.id+' >'+
                        '<option value="'+val.role+'" selected >'+
                          check_role(val.role)+
                        '</option>'+
                        '<option value="'+0+'">'+
                          'User'+
                        '</option>'+
                        '<option value="'+1+'">'+
                          'Admin'+
                        '</option>'+
                      '</select>'+
                    '</td>'+
                    '<td>'+
                      '<form id="myform" method="post" action="'+val.id+'">'+
                        '<input type="hidden" name="_method" value="DELETE">'+
                        '<input type="hidden" name="authenticity_token" value="oBCh5cBaXsGH vc86VmeXdlry2KWFT7KA1dT6ZZ6949bKPPM6FxD84cD//Pm/EDqttkiNJPA5rI5oXJfVOdLpVw==">'+
                        '<input type="submit" value="DELETE">'+
                      '</form>'+
                    '</td>'+
                  '</tr>'
        });
        $('#table_user').html(html)
      }
    });
  });
});


function check_role(role) {
  return role == 0 ? 'User' : 'Admin'
}

function check_null(nil) {
  return nil == null ? '' : nil
}
