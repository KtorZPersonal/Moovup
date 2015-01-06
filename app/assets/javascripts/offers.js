function getDistanceDate(date_val){
  var date = new Date(date_val);
  var now = new Date();
  var hours = (date.getTime() - now.getTime())/(1000*60*60);
  var distance_date;
  if(isNaN(hours) || hours < 0){
    distance_date = "-"
  }else{
    if(hours > 24){
      var days = Math.ceil(hours/24)
      if(days == 1){
        distance_date = "1 jour"
      }else{
        if(days > 30){
          var months = Math.floor(days/30)
          distance_date = months+" mois"
        }else{
          distance_date = days+" jours"
        }
      }
    }else{
      if(hours < 1){
        distance_date = "moins d'une heure"
      }else{
        distance_date = Math.floor(hours)+" heures"
      }
    }
  }
  return distance_date
}
function resize(e){
  var img  = new Image()
  img.src = e.target.result
  img.onload = function(){
    var width = 300; var height = 300;
    var margin_left = 0; var margin_top = 0;
    var w = this.width; var h = this.height
    if(w >= 300 && h >= 300){
      if(w > h){
        width = Math.floor(w*300/h);
        margin_left = (width-300)/2;
      }else{
        height = Math.floor(h*300/w);
        margin_top = (height-300)/2;
      }
    }else{
      if(w < 300){
        height = Math.floor(h*300/w);
        h = height;
        w = 300;
        margin_top = (height-300)/2;
      }
      if(h < 300){
        height = 300;
        width = Math.floor(w*300/h);
        margin_top = 0;
        margin_left = (width-300)/2;
      }
    }
    // alert("Width: "+width+"; height: "+height);
    $("#preview_photo_display").css({
      width: width,
      height: height,
      'margin-left': -margin_left,
      'margin-top': -margin_top
    }) 
  }
}


$(function(){
  $('.form-control-preview').on('change', function(){
    var id = $(this).attr('id');
    if(id == "preview_expiry"){
      $("#"+id+"_display").text("Pendant "+getDistanceDate($(this).val()));
    }else{
      $("#"+id+"_display").text($(this).val())
    }
  })

  $('#offer_photo').on('change', function(){
    var input = $(this)[0]
    if(input.files && input.files[0]){
        var reader = new FileReader()
        reader.onload = function(e){
          resize(e);
          $("#preview_photo_display").attr('src', e.target.result)
        }
        reader.readAsDataURL(input.files[0])
    }
  });
});