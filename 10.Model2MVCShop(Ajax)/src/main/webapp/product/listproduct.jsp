<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<!-- CDN(Content Delivery Network) 호스트 사용 -->
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<script type="text/javascript">
	function fncGetProductList(currentPage) {
		//document.getElementById("currentPage").value = currentPage;
		$("#currentPage").val(currentPage)
	   	//document.detailForm.submit();
		$("form").attr("method" , "GET").attr("action" , "/product/listProduct").submit();
	}
	$(function() {
		var menu = "${menu}"; 
		 
		//==> 검색 Event 연결처리부분
		//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
		//==> 1 과 3 방법 조합 : $("tagName.className:filter함수") 사용함. 
		 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
			//Debug..
			//alert(  $( "td.ct_btn01:contains('검색')" ).html() );
			fncGetProductList(1);
		});
		
		//==> userId LINK Event 연결처리
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			//==> 3 과 1 방법 조합 : $(".className tagName:filter함수") 사용함.
			$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
				var prodNo = $(this).closest("tr").data("prodno");
					//Debug..
					//alert(  $( this ).text().trim() );${vo.prodNo}
					//self.location ="/product/getProduct?prodNo="+$(this).text().trim()+"&menu=${menu}";
				//self.location ="/product/getProduct?prodNo="+$(this).text().trim()+"&menu=${menu}";
				//현: $(this).text() 이건 클릭한 상품명을 반환하니 바꿈
				var doubleClick = $("#"+prodNo);//현:더블클릭 닫치기 추가 jquery에 prodNo에 해당하는 id를 가진게 있으면 선택
				if(doubleClick.children().length>0){//현:이미 정보가 있는 경우 해당 자식이 있으면 0 초가니
					doubleClick.empty();//현:제거
				}
				else{
				<c:if test="${menu == 'manage'}">
				self.location = "/product/updateProductView?prodNo=" + prodNo + "&menu=${menu}";
				</c:if>
				<c:if test="${menu == 'search'}">
				var prodNo = $(this).closest("tr").data("prodno");
				$.ajax( 
						{
							url : "/product/json/getProduct/"+prodNo ,
							method : "GET" ,
							dataType : "json" ,
							headers : {
								"Accept" : "application/json",
								"Content-Type" : "application/json"
							},
							success : function(JSONData , status) {

								//Debug...
								//alert(status);
								//Debug...
								//alert("JSONData : \n"+JSONData);
								
								var displayValue = "<h3>"
															+"상품번호 : "+JSONData.prodNo+"<br/>"
															+"상품명: "+JSONData.prodName+"<br/>"
															+"상품상세정보 : "+JSONData.prodDetail+"<br/>"
															+"가격 : "+JSONData.price+"<br/>"
															+"제조일자: "+JSONData.manuDate+"<br/>"
															+"등록일 : "+JSONData.regDateString+"<br/>"
															+"상품이미지 : "+JSONData.fileName+"<br/>"
															+"</h3>";
								//Debug...									
								//alert(displayValue);
								$("h3").remove();
								$( "#"+prodNo+"" ).html(displayValue);
							}
					});
				//self.location = "/product/getProduct?prodNo=" + $(this).closest("tr").data("prodno") + "&menu=${menu}";
				</c:if>
				}
				
			});
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
			$("h7").css("color" , "red");
			//==> 아래와 같이 정의한 이유는 ??
			$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");//색 구분되며 출력 잘 되는지
	});		
		
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

 <!--<form name="detailForm" action="/product/listProduct" method="get">  -->
 <form name="detailForm">
<input type="hidden" name="menu" value="${menu}">


<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <c:if test="${menu=='manage'}">
						<td width="93%" class="ct_ttl01">상품 관리</td>
					</c:if>
					<c:if test="${menu=='search'}">
						<td width="93%" class="ct_ttl01">상품 검색</td>
					</c:if>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
        <select name="searchCondition" class="ct_input_g" style="width:80px" >
        	<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" :'' }>상품번호</option>
        	<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" :''}>상품명</option>
        	<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" :''}>상품가격</option>
        </select>
        <input type="text" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword:''}"  
						class="ct_input_g" style="width:200px; height:20px" > 
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!--<a href="javascript:fncGetProductList('1');">검색</a>  -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체  ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage}  페이지</td>
	</tr>
	<tr>
		<!-- <td class="ct_list_b" width="100">No</td>상품번호로 상세검색  -->
		<td class="ct_list_b" width="100">
				No
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명<br>
		<h7>(no click:상세정보)</h7></td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<c:set var="i" value="0" />
	<c:forEach var="vo" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop" data-prodno="${vo.prodNo}">
		<td align="center">${ i }</td>
		<td></td>
		<c:if test="${menu=='manage'}" >
			<!-- <td align="left"><a href="/product/updateProductView?prodNo=${vo.prodNo}&menu=${param.menu}">${vo.prodName}</a></td> -->
			${vo.prodName}
		</c:if>
		<td>${vo.prodName}</td>
		<td></td>
		<td align="left">${vo.price}</td>
		<td></td>
		<td align="left">${vo.regDate}</td>
		<td></td>
		<td align="left">
			판매중
		</td>	
	</tr>
	<tr>
		<td id= "${vo.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		<input type="hidden" id="currentPage" name="currentPage" value=""/>
		
		<jsp:include page="../common/pageNavigator2.jsp"/>
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
