
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.define("hello2", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("CCTest", function(request, response) {

  var arrData = [
    				{ key: 'row', val: 'first row' },
    				{ key: 'row', val: 'second row' },
    				{ key: 'row', val: 'third' },
    				{ key: 'row', val: 'fourth' },
    				{ key: 'row', val: 'fifth' },
    				{ key: 'row', val: 'sixth' },
    				{ key: 'row', val: 'seventh' },
				  ]
    
    var arrResult=[];

    if (request.params.skip && request.params.limit) {
        
    	arrResult = arrData.slice(request.params.skip, request.params.skip+request.params.limit)
    }else{
		
		arrResult = arrData;    	
    }

  return response.success(arrResult);
  response.success("all good");
});