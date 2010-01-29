$.fn.pagination=function(opts){
	//encodeURI
	this.each(function(){
		var currPage=1;
		var panel=$(this);
		var pages = Math.ceil(opts.count/opts.pageCount);
		function optPage(page){
			currPage=page;
			render();
			opts.callback(page);
		}
		function render(){
			var strHtml=new String();
			strHtml+="<ul id='pagination'><li id='text'>共有"+opts.count+"条记录,当前第"+currPage+"页,共"+pages+"页</li>";
			strHtml+="<li><img alt='首页' id='first' /></li>";
			strHtml+="<li><img alt='上一页' id='prev' /></li>";
			strHtml+="<li><img alt='下一页' id='next' /></li>";
			strHtml+="<li><img alt='尾页' id='last' /></li>";
			strHtml+="<li style='padding:10px;'>转到第<input type='text' id='turn' />页<input class='go' type='button' value='GO'/></li></ul>";
			panel.empty();
			panel.append(strHtml);

			var imgPath=opts.imagePath;
			var imgs=["/first-disabled.gif","/prev-disabled.gif","/next-disabled.gif","/last-disabled.gif"];
			var css=["disabledFalse","disabledFalse"];
			if(currPage>1){
				imgs[0]="/first.gif"
				imgs[1]="/prev.gif";
				$("#first",panel).click(function(){
					optPage(1);
				});
				$("#prev",panel).click(function(){
					optPage(currPage-1);
				});
				css[0]="disabledTrue";
			}
			if(currPage < pages){
				imgs[2]="/next.gif";
				imgs[3]="/last.gif";
				$("#next",panel).bind("click",function(){
					optPage(currPage+1);
				});
				$("#last",panel).bind("click",function(){
					optPage(pages);
				});
				css[1]="disabledTrue";
			}
			$("input.go").click(function(){
				try{
					var turn=parseInt($("#turn").val());
					if(turn<1 || turn>pages || !turn){
						alert("Input error! Must for the digital and can only be between 1 and "+pages+".");
					}else{
						optPage(turn);
					}
				}catch(e){
					alert("Only for digital input."+e.message);
				}
			});
			//save id
			var ids=["#first","#prev","#next","#last"];
			$.each(imgs,function(i,n){
				var obj=$(ids[i]).attr("src",imgPath+n).addClass(css[Math.floor(i/2)]);
			});
		}
		render();
	});
}