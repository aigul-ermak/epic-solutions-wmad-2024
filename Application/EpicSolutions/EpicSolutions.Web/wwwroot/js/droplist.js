$(document).ready(function () {   

    $('#role').attr('disabled', true);
    $('#department').attr('disabled', true);
    $('#supervisors').attr('disabled', true);

    var positionId = $('#jobAssignment').val();

    // Load roles, departments, and supervisors based on the initial position ID
    if (positionId > 0) {
        LoadRoles(positionId);
        LoadDepartments(positionId);
        LoadSupervisors(positionId);
    }

    // Change event handler for the job assignment dropdown
    $('#jobAssignment').change(function () {
        var positionId = $(this).val();

        if (positionId > 0) {
            LoadRoles(positionId);
            LoadDepartments(positionId);
            LoadSupervisors(positionId);
        }
    });    

    //$('#jobAssignment').change(function () {
     
    //    var positionId = $(this).val();

    //    if (positionId > 0) {
    //        LoadRoles(positionId);
    //        LoadDepartments(positionId);
    //        LoadSupervisors(positionId);
    //    }
    //});    
})


function LoadRoles(positionId) {
    $('#role').empty();


    $.ajax({
        url: '/Employee/getRoles?Id=' + positionId,
        success: function (response) {
            if (response != null && response != undefined && response.length > 0) {
                $('#role').attr('disabled', false);
                $.each(response, function (i, data) {
                    $('#role').append('<option value=' + data.id + '>' + data.name + '</option>')
                });

            } else {
                $('#role').attr('disabled', true);
                $('#role').append('<option>--Role is not available--</option>');

            }
        },
        error: function (error) {
            alert(error);
        }
    })
}

function LoadDepartments(positionId) {
    $('#department').empty();
    $('#department').attr('disabled', true);

    $.ajax({
        url: '/Employee/getDepartments?Id=' + positionId,
        success: function (response) {
            if (response != null && response != undefined && response.length > 0) {
                $('#department').attr('disabled', false);            
                $.each(response, function (i, data) {
                    $('#department').append('<option value=' + data.id + '>' + data.name + '</option>')
                });             
            } else {
             
                $('#department').attr('disabled', true);               
                $('#department').append('<option>--City not available--</option>');

            }
        },
        error: function (error) {
            alert(error);
        }
    })
}

function LoadSupervisors(positionId) {
    $('#supervisors').empty();
    $('#supervisors').attr('disabled', true);


    $.ajax({
        url: '/Employee/getSupervisorsByPositionId?PositionId=' + positionId,
        success: function (response) {
            if (response != null && response != undefined && response.length > 0) {
                $('#supervisors').attr('disabled', false);
                $.each(response, function (i, data) {
                    $('#supervisors').append('<option value=' + data.id + '>' + data.name + '</option>')
                });
            } else {
                $('#supervisors').attr('disabled', true);
                $('#supervisors').append('<option>--Supervisors not available--</option>');

            }
        },
        error: function (error) {
            alert(error);
        }
    })
}

