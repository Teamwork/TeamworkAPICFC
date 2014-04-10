Teamwork.com API CFC
==============

Teamwork.com API CFC for ColdFusion.

View our [Developer Site](http://developer.teamwork.com/apicomponent) For a list of methods and examples.

Quick Example
-------------

```CFML
<cfsetting enablecfoutputonly="No">

<cfset LOCAL.baseHref = "https://yoursite.teamwork.com/">
<cfset LOCAL.APIKey = "myKey">

<cfset LOCAL.taskId = 1234567>

<cfsavecontent variable="LOCAL.commentBody">
This is a test comment.

This uses the TeamworkAPI CFC
</cfsavecontent>

<cfset LOCAL.teamworkAPIObj = new teamworkpmAPI( LOCAL.baseHref , LOCAL.APIKey )>

<cfset LOCAL.response = LOCAL.teamworkAPIObj.newComment(
	objectId	=	LOCAL.taskId,
	type		=	"task",
	body		=	LOCAL.commentBody
)>

<cfdump var="#LOCAL.response#">
```
