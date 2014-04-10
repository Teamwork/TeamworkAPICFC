<cfcomponent name="teamworkPMAPI">
	<cfset this.baseHref = "">
	<cfset this.apiKey = "">
	<cfset this.debug = false>
	<cfset this.counter = 10000>
		
	<cfset argToEleMap.projectId = "project-id" >
	<cfset argToEleMap.milestoneId = "milestone-id" >
	<cfset argToEleMap.todoListTemplateId = "todo-list-template-id" >
	<cfset argToEleMap.useTasks ="use-tasks">
	<cfset argToEleMap.useMilestones = "use-milestones">
	<cfset argToEleMap.useMessages = "use-messages">
	<cfset argToEleMap.useFiles = "use-files">
	<cfset argToEleMap.useTime = "use-time">
	<cfset argToEleMap.useNotebook = "use-notebook">
	<cfset argToEleMap.useRiskregister = "use-riskregister">
	<cfset argToEleMap.useResources = "use-resources">
	<cfset argToEleMap.responsibleParty = "responsible-party-id">
	<cfset argToEleMap.dueAt = "due-date">
	<cfset argToEleMap.attachedFileIds = "attached-file-ids">
	<cfset argToEleMap.attachedTempFileIds = "attached-temp-file-ids">		
	<cfset argToEleMap.categoryId = "category-id">	
	<cfset argToEleMap.personId = "person-id">	
	<cfset argToEleMap.content = "content">	

	<cffunction name="init" output="true" returntype="teamworkPMAPI">
		<cfargument name="baseHref" type="string" required="yes">
		<cfargument name="apiKey" type="string" required="yes">
		<cfargument name="debug" type="string" required="no" default="false">

		<cfset this.baseHref = ARGUMENTS.baseHref>
		<cfset this.apiKey = ARGUMENTS.apiKey>
		<cfset this.debug = ARGUMENTS.debug>
		
		<cfif this.debug EQ true>
			<cfoutput>
			<style type="text/css">
				div.debugContainer {font-family: courier new; position: relative; min-height: 50px; padding: 10px 20px 10px 30px; border-bottom: 1px ##aaa dashed; }
				div.debugContainer h3 { line-height: 10px; font-weight: bold; }
				div.debugContainer h3 span { font-weight: normal; background: ##EDF5F4; color: ##000; }
				div.debugContainer div.info { margin-left: 20px; }
				div.status { position: absolute;top: 0px;left: 0px; height: 100%; }
			</style>
			</cfoutput>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	

<!---
	Call Functions	
--->

<!---
	Projects
--->

	<cffunction name="newProject" returntype="struct">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="description" required="no" type="string">
		<cfargument name="useTasks" required="no" type="string">
		<cfargument name="useMilestones" required="no" type="string">
		<cfargument name="useMessages" required="no" type="string">
		<cfargument name="useFiles" required="no" type="string">
		<cfargument name="useTime" required="no" type="string">
		<cfargument name="useNotebook" required="no" type="string">
		<cfargument name="useRiskregister" required="no" type="string">
		<cfargument name="useResources" required="no" type="string">
										
		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("project", ARGUMENTS)>

		<cfset responseObject = this.runAPICall(
			call = "POST /projects.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>
	

	<cffunction name="getProject" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "GET /projects/#ARGUMENTS.projectId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	

	<cffunction name="getProjects" returntype="struct">
		<cfset var responseObject = this.runAPICall(
			call = "GET /projects.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="getStarredProjects" returntype="struct">
		<cfset var responseObject = this.runAPICall(
			call = "GET /projects/starred.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="starProject" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "PUT /projects/#ARGUMENTS.projectId#/star.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	

	<cffunction name="unstarProject" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "PUT /projects/#ARGUMENTS.projectId#/unstar.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="deleteProject" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "PUT /projects/#projectId#/delete.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>

<!---
	Companies
--->

	<cffunction name="getCompanies" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">
		
		<cfset var responseObject = StructNew()>
			
		<cfif NOT StructKeyExists( ARGUMENTS, "projectId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /companies.json"
			)>
		<cfelse>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/companies.json"
			)>
		</cfif>
		
		<cfreturn responseObject>
	</cffunction>
	
<!---
	People
--->

	<cffunction name="getMe" returntype="struct">
		<cfset var responseObject = this.runAPICall(
			call = "GET /me.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="getPeople" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">
		<cfargument name="companyId" required="no" type="numeric">
			
		<cfset var responseObject = StructNew()>	
			
		<cfif StructKeyExists(ARGUMENTS, "projectId")>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/people.json"
			)>

		<cfelseif StructKeyExists(ARGUMENTS, "companyId")>
			<cfset responseObject = this.runAPICall(
				call = "GET /companies/#ARGUMENTS.companyId#/people.json"
			)>
		<cfelse>
			<cfset responseObject = this.runAPICall(
				call = "GET /people.json"
			)>
		</cfif>
		
		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="getPerson" returntype="struct">
		<cfargument name="userId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "GET /people/#ARGUMENTS.userId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
<!---
	Todo Lists
--->

	<cffunction name="getTodoLists" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">
		<cfargument name="filter" required="no" type="string">
		
		<cfset var parameters = StructNew()>
		<cfset var responseObject = StructNew()>
		
		<cfif NOT StructKeyExists( ARGUMENTS, "projectId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /todo_lists.json"
			)>
		<cfelse>
			<cfif StructKeyExists( ARGUMENTS, "filter" )>
				<cfset parameters["filter"] = ARGUMENTS.filter>
			
				<cfset responseObject = this.runAPICall(
					call = "GET /projects/#ARGUMENTS.projectId#/todo_lists.json",
					params = parameters
				)>
			<cfelse>
				<cfset responseObject = this.runAPICall(
					call = "GET /projects/#ARGUMENTS.projectId#/todo_lists.json"
				)>
			</cfif>
		</cfif>
		
		<cfreturn responseObject>
		</cffunction>


	<cffunction name="getTodoList" returntype="struct">
		<cfargument name="todoListId" required="yes" type="string">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /todo_lists/#todoListId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newTodoList" returntype="struct">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="private" required="no" type="string">
		<cfargument name="description" required="no" type="string">
		<cfargument name="milestoneId" required="no" type="string">
		<cfargument name="todoListTemplateId" required="no" type="string">
		<cfargument name="position" required="no" type="string">
		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("todo-list", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "POST /projects/#ARGUMENTS.projectId#/todo_lists.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateTodoList" returntype="struct">
		<cfargument name="todoListId" required="yes" type="numeric">
		<cfargument name="name" required="no" type="string">
		<cfargument name="private" required="no" type="string">
		<cfargument name="description" required="no" type="string">
		<cfargument name="milestoneId" required="no" type="string">
		<cfargument name="todoListTemplateId" required="no" type="string">
		<cfargument name="position" required="no" type="string">
		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("todo-list", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "PUT /todo_lists/#ARGUMENTS.todoListId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="reorderTodoLists" returntype="struct">
		<cfargument name="todoListIds" required="yes" type="array">
		<cfargument name="projectId" required="yes" type="string">
				
		<cfset var responseObject = StructNew()>
		<cfset var requestBody = "">
		<cfset var todoLists = StructNew()>
		<cfset todoLists["todo-list"] = ArrayNew(1)>
		
		<cfloop index="key" from="1" to="#arrayLen(ARGUMENTS.todoListIds)#">
		 	<cfset todoLists["todo-list"][key]["id"] = StructNew()>
			<cfset todoLists["todo-list"][key]["id"] = ARGUMENTS.todoListIds[key]>
		</cfloop>
		
		<cfset requestBody = buildRequestBody("todo-lists", todoLists)>

		<cfset responseObject = this.runAPICall(
			call = "POST /projects/#ARGUMENTS.projectId#/todo_lists/reorder.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="deleteTodoList" returntype="struct">
		<cfargument name="todoListId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /todo_lists/#ARGUMENTS.todoListId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>

<!---
	Todo Items
--->
	<cffunction name="getTodoItems" returntype="struct">
		<cfargument name="todoListId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /todo_lists/#ARGUMENTS.todoListId#/todo_items.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>



	<cffunction name="getTodoItem" returntype="struct">
		<cfargument name="todoItemId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /todo_items/#ARGUMENTS.todoItemId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="completeTodoItem" returntype="struct">
		<cfargument name="todoItemId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "PUT /todo_items/#ARGUMENTS.todoItemId#/complete.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="uncompleteTodoItem" returntype="struct">
		<cfargument name="todoItemId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "PUT /todo_items/#ARGUMENTS.todoItemId#/uncomplete.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newTodoItem" returntype="struct">
		<cfargument name="todoListId" required="yes" type="numeric">
		<cfargument name="content" required="yes" type="string">
		<cfargument name="notify" required="no" type="array">
		<cfargument name="responsibleParty" required="no" type="string">
		<cfargument name="dueAt" required="no" type="string">
		<cfargument name="description" required="no" type="string">
		<cfargument name="private" required="no" type="string">
		<cfargument name="priority" required="no" type="string">
		<cfargument name="attachedFileIds" required="no" type="string">
		<cfargument name="attachedTempFileIds" required="no" type="string">
		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("todo-item", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "POST /todo_lists/#ARGUMENTS.todoListId#/todo_items.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateTodoItem" returntype="struct">
		<cfargument name="todoItemId" required="yes" type="numeric">
		<cfargument name="content" required="yes" type="string">
		<cfargument name="notify" required="no" type="array">
		<cfargument name="responsibleParty" required="no" type="string">
		<cfargument name="dueAt" required="no" type="string">
		<cfargument name="description" required="no" type="string">
		<cfargument name="private" required="no" type="string">
		<cfargument name="priority" required="no" type="string">
		<cfargument name="attachedFileIds" required="no" type="string">
		<cfargument name="attachedTempFileIds" required="no" type="string">
		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("todo-item", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "PUT /todo_items/#ARGUMENTS.todoItemId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="reorderTodoItems" returntype="struct">
		<cfargument name="todoItemIds" required="yes" type="array">
		<cfargument name="todoListId" required="yes" type="string">
				
		<cfset var responseObject = StructNew()>
		<cfset var requestBody = "">
		<cfset var todoItems = StructNew()>
		<cfset todoItems["todo-item"] = ArrayNew(1)>
		
		<cfloop index="key" from="1" to="#arrayLen(ARGUMENTS.todoItemIds)#">
		 	<cfset todoItems["todo-item"][key]["id"] = StructNew()>
			<cfset todoItems["todo-item"][key]["id"] = ARGUMENTS.todoItemIds[key]>
		</cfloop>
		
		<cfset requestBody = buildRequestBody("todo-items", todoItems)>

		<cfset responseObject = this.runAPICall(
			call = "POST /todo_lists/#ARGUMENTS.todoListId#/todo_items/reorder.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="deleteTodoItem" returntype="struct">
		<cfargument name="todoItemId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /todo_items/#ARGUMENTS.todoItemId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>

<!---
	Milestones
--->

	<cffunction name="getMilestones" returntype="struct">
		<cfargument name="filter" required="no" type="string">
		
		<cfset var parameters = StructNew()>
		<cfset var responseObject = StructNew()>
		
		<cfif StructKeyExists( ARGUMENTS, "filter" )>
			<cfset parameters["find"] = ARGUMENTS.filter>
			
			<cfset responseObject = this.runAPICall(
				call = "GET /milestones.json",
				params = parameters
			)>
		<cfelse>
			<cfset responseObject = this.runAPICall(
				call = "GET /milestones.json"
			)>
		</cfif>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newMilestone" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="title" required="yes" type="string">
		<cfargument name="deadline" required="yes" type="string">
		<cfargument name="responsibleParty" required="yes" type="numeric">
		<cfargument name="notify" required="no" type="boolean">
		<cfargument name="private" required="no" type="string">

		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("milestone", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "POST /projects/#ARGUMENTS.projectId#/milestones.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateMilestone" returntype="struct">
		<cfargument name="milestoneId" required="yes" type="numeric">
		<cfargument name="title" required="no" type="string">
		<cfargument name="deadline" required="no" type="string">
		<cfargument name="responsibleParty" required="no" type="numeric">
		<cfargument name="notify" required="no" type="boolean">
		<cfargument name="private" required="no" type="string">

		
		<cfset var responseObject = StructNew()>
		
		<cfset var requestBody = buildRequestBody("milestone", ARGUMENTS)>
			
		<cfset responseObject = this.runAPICall(
			call = "PUT /milestones/#ARGUMENTS.milestoneId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="completeMilestone" returntype="struct">
		<cfargument name="milestoneId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "PUT /milestones/#ARGUMENTS.milestoneId#/complete.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="uncompleteMilestone" returntype="struct">
		<cfargument name="milestoneId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "PUT /milestones/#ARGUMENTS.milestoneId#/uncomplete.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="deleteMilestone" returntype="struct">
		<cfargument name="milestoneId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /milestones/#ARGUMENTS.milestoneId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
<!---
	Categories
	Allowed types are: notebook, file, message and resource
--->

	<cffunction name="getCategories" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="type" required="no" type="string" default="message">
		
		<cfset var responseObject = this.runAPICall(
			call = "GET /projects/#ARGUMENTS.projectId#/#ARGUMENTS.type#categories.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="getCategory" returntype="struct">
		<cfargument name="categoryId" required="yes" type="numeric">
		<cfargument name="type" required="no" type="string" default="message">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /#ARGUMENTS.type#categories/#ARGUMENTS.categoryId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newCategory" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="type" required="no" type="string" default="message">
		
		<cfset var requestBody = buildRequestBody("category", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "POST /projects/#ARGUMENTS.projectId#/#ARGUMENTS.type#categories.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateCategory" returntype="struct">
		<cfargument name="categoryId" required="yes" type="numeric">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="type" required="no" type="string" default="message">
		
		<cfset var requestBody = buildRequestBody("category", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "PUT /#ARGUMENTS.type#categories/#ARGUMENTS.categoryId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="deleteCategory" returntype="struct">
		<cfargument name="categoryId" required="yes" type="numeric">
		<cfargument name="type" required="no" type="string" default="message">
			
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /#ARGUMENTS.type#categories/#ARGUMENTS.categoryId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>

	
<!---
	Messages
	*Needs archive messages by project ID*
--->
	<cffunction name="getRecentMessages" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="categoryId" required="no" type="numeric">
		
		<cfset var responseObject = StructNew()>
			
		<cfif StructKeyExists( ARGUMENTS, "categoryId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/cat/#ARGUMENTS.categoryId#/posts.json"
			)>			
		<cfelse>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/posts.json"
			)>		
		</cfif>

		<cfreturn responseObject>
	</cffunction>


	<cffunction name="getMessage" returntype="struct">
		<cfargument name="messageId" required="yes" type="numeric">

		<cfset var responseObject = this.runAPICall(
			call = "GET /posts/#ARGUMENTS.messageId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	

	<cffunction name="newMessage" returntype="struct">
		<cfargument name="projectId" required="yes" type="numeric">
		<cfargument name="title" required="yes" type="string">
		<cfargument name="body" required="yes" type="string">
		<cfargument name="categoryId" required="yes" type="string">
		<cfargument name="notify" required="no" type="array">
		<cfargument name="private" required="no" type="string">
		<cfargument name="attachments" required="no" type="array">
		
		<cfset var requestBody = buildRequestBody("post", ARGUMENTS, "request")>
		
		<cfset responseObject = this.runAPICall(
			call = "POST /projects/#ARGUMENTS.projectId#/posts.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateMessage" returntype="struct">
		<cfargument name="messageId" required="yes" type="numeric">
		<cfargument name="title" required="no" type="string">
		<cfargument name="body" required="no" type="string">
		<cfargument name="categoryId" required="no" type="string">
		<cfargument name="notify" required="no" type="array">
		<cfargument name="private" required="no" type="string">
		<cfargument name="attachments" required="no" type="array">
		
		<cfset var requestBody = buildRequestBody("post", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "PUT /posts/#ARGUMENTS.messageId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>
	

	<cffunction name="deleteMessage" returntype="struct">
		<cfargument name="messageId" required="yes" type="numeric">

		<cfset var responseObject = this.runAPICall(
			call = "DELETE /posts/#ARGUMENTS.messageId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>

<!---
	Messages Replies
--->
	<cffunction name="getMessageReplies" returntype="struct">
		<cfargument name="messageId" required="yes" type="numeric">
		
		<cfset var responseObject = this.runAPICall(
			call = "GET /messages/#ARGUMENTS.messageId#/replies.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="getMessageReply" returntype="struct">
		<cfargument name="messageReplyId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /messageReplies/#ARGUMENTS.messageReplyId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newMessageReply" returntype="struct">
		<cfargument name="messageId" required="yes" type="numeric">
		<cfargument name="body" required="yes" type="string">
		<cfargument name="notify" required="no" type="array">
		<cfargument name="private" required="no" type="string">
		<cfargument name="attachments" required="no" type="array">
						
		<cfset var requestBody = buildRequestBody("messageReply", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "POST /messages/#ARGUMENTS.messageId#/replies.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateMessageReply" returntype="struct">
		<cfargument name="messageReplyId" required="yes" type="numeric">
		<cfargument name="body" required="no" type="string">
		<cfargument name="attachments" required="no" type="array">
						
		<cfset var requestBody = buildRequestBody("messageReply", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "PUT /messageReplies/#ARGUMENTS.messageReplyId#.json",
			body = requestBody
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="deleteMessageReply" returntype="struct">
		<cfargument name="messageReplyId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /messageReplies/#ARGUMENTS.messageReplyId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>	

<!---
	Time Tracking
--->
	<cffunction name="getTimeEntries" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">
		<cfargument name="todoItemId" required="no" type="numeric">
		
		<cfset var responseObject = StructNew()>	
		
		<cfif StructKeyExists( ARGUMENTS, "projectId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/time_entries.json"
			)>
		<cfelseif StructKeyExists( ARGUMENTS, "todoItemId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /todo_items/#ARGUMENTS.todoItemId#/time_entries.json"
			)>
		</cfif>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="getTimeEntry" returntype="struct">
		<cfargument name="timeEntryId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "GET /time_entries/#ARGUMENTS.timeEntryId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="newTimeEntry" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">
		<cfargument name="todoItemId" required="no" type="numeric">
		<cfargument name="personId" required="yes" type="numeric">
		<cfargument name="date" required="yes" type="string">
		<cfargument name="hours" required="no" type="numeric">
		<cfargument name="minutes" required="no" type="numeric">
		<cfargument name="description" required="no" type="string">
		<cfargument name="time" required="no" type="string">

		<cfset var responseObject = StructNew()>
		<cfset var requestBody = buildRequestBody("time-entry", ARGUMENTS)>
			
		<cfif StructKeyExists( ARGUMENTS, "projectId" )>
			<cfset responseObject = this.runAPICall(
				call = "POST /projects/#ARGUMENTS.projectId#/time_entries.json",
				body = requestBody
			)>
		<cfelseif StructKeyExists( ARGUMENTS, "todoItemId" )>
			<cfset responseObject = this.runAPICall(
				call = "POST /todo_items/#ARGUMENTS.todoItemId#/time_entries.json",
				body = requestBody
			)>
		</cfif>
		
		<cfreturn responseObject>
	</cffunction>


	<cffunction name="updateTimeEntry" returntype="struct">
		<cfargument name="timeEntryId" required="yes" type="numeric">
		<cfargument name="personId" required="no" type="numeric">
		<cfargument name="date" required="yes" type="string">
		<cfargument name="hours" required="no" type="numeric">
		<cfargument name="minutes" required="no" type="numeric">
		<cfargument name="description" required="no" type="string">
		<cfargument name="time" required="no" type="string">

		<cfset var requestBody = buildRequestBody("time-entry", ARGUMENTS)>
			
		<cfset var responseObject = this.runAPICall(
			call = "PUT /time_entries/#ARGUMENTS.timeEntryId#.json",
			body = requestBody
		)>

		<cfreturn responseObject>
	</cffunction>
	
	<cffunction name="deleteTimeEntry" returntype="struct">
		<cfargument name="timeEntryId" required="yes" type="numeric">
			
		<cfset var responseObject = this.runAPICall(
			call = "DELETE /time_entries/#ARGUMENTS.timeEntryId#.json"
		)>
		
		<cfreturn responseObject>
	</cffunction>
	
<!---
	Comments
--->
	<cffunction name="getComments" returntype="struct">
		<cfargument name="objectId" required="yes" type="numeric">
		<cfargument name="type" required="no" type="string" default="todoItem">
		
		<cfset var responseObject = StructNew()>
		<cfset var objectType = "">
			
		<cfswitch expression="ARGUMENTS.type">
			<cfcase value="file">
				<cfset objectType = "fileversions">
			</cfcase>
			<cfcase value="milestone">
				<cfset objectType = "milestones">
			</cfcase>
			<cfcase value="notebook">
				<cfset objectType = "notebooks">
			</cfcase>
			<cfdefaultcase>
				<cfset objectType = "todo_items">				
			</cfdefaultcase>
		</cfswitch>
		
		<cfset responseObject = this.runAPICall(
			call = "GET /#objectType#/#ARGUMENTS.objectId#/comments.json"
		)>

		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="getComment" returntype="struct">
		<cfargument name="commentId" required="yes" type="numeric">
		
		<cfset var responseObject = StructNew()>
		
		<cfset responseObject = this.runAPICall(
			call = "GET /comments/#ARGUMENTS.commentId#.json"
		)>

		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="newComment" returntype="struct">
		<cfargument name="objectId" required="yes" type="numeric">
		<cfargument name="type" required="yes" type="string">
		<cfargument name="body" required="yes" type="string">
		<cfargument name="isPrivate" required="no" type="string">
		<cfargument name="threshold" required="no" type="numeric">
			
		<cfset var responseObject = StructNew()>
		<cfset var objectType = "">
		<cfset var requestBody = "">
		
		<cfswitch expression="#ARGUMENTS.type#">
			<cfcase value="file">
				<cfset objectType = "fileversions">
			</cfcase>
			<cfcase value="milestone">
				<cfset objectType = "milestones">
			</cfcase>
			<cfcase value="notebook">
				<cfset objectType = "notebooks">
			</cfcase>
			<cfcase value="task,todo_item">
				<cfset objectType = "tasks">
			</cfcase>
			<cfcase value="link">
				<cfset objectType = "links">
			</cfcase>
			<cfdefaultcase>
				<cfset objectType = "todo_items">				
			</cfdefaultcase>
		</cfswitch>
		
		<cfset requestBody = buildRequestBody("comment", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "POST /#objectType#/#ARGUMENTS.objectId#/comments.json",
			body = requestBody
		)>

		<cfreturn responseObject>
	</cffunction>	
	
	
	<cffunction name="updateComment" returntype="struct">
		<cfargument name="commentId" required="yes" type="numeric">
		<cfargument name="body" required="no" type="string">
		<cfargument name="isPrivate" required="no" type="string">
		<cfargument name="threshold" required="no" type="numeric">
			
		<cfset var responseObject = StructNew()>
		<cfset var objectType = "">
		<cfset var requestBody = "">
		
		<cfset requestBody = buildRequestBody("comment", ARGUMENTS)>
		
		<cfset responseObject = this.runAPICall(
			call = "PUT /comments/#ARGUMENTS.commentId#.json",
			body = requestBody
		)>

		<cfreturn responseObject>
	</cffunction>
	
	
	<cffunction name="deleteComment" returntype="struct">
		<cfargument name="commentId" required="yes" type="numeric">
		
		<cfset var responseObject = StructNew()>
		<cfset var objectType = "">
		
		<cfset responseObject = this.runAPICall(
			call = "DELETE /comments/#ARGUMENTS.commentId#.json"
		)>

		<cfreturn responseObject>
	</cffunction>
	

<!---
	Activity
--->
	<cffunction name="getActivity" returntype="struct">
		<cfargument name="projectId" required="no" type="numeric">	
		
		<cfset var responseObject = StructNew()>
		
		<cfif NOT StructKeyExists( ARGUMENTS, "projectId" )>
			<cfset responseObject = this.runAPICall(
				call = "GET /activity.json"
			)>
		<cfelse>
			<cfset responseObject = this.runAPICall(
				call = "GET /projects/#ARGUMENTS.projectId#/activity.json"
			)>			
		</cfif>
		<cfreturn responseObject>
	</cffunction>
	
	
<!---
	Helper functions
--->
	<cffunction name="runAPICall" returntype="struct">
		<cfargument name="call" type="string" required="yes">
		<cfargument name="body" type="string" required="no">
		<cfargument name="params" type="struct" required="no" >
		
		<cfset var locals = StructNew()>
		<cfset var response = StructNew()>
		<cfset response.object = StructNew()>
        <cfset response.header = StructNew()>
        <cfset response.status = "OK">
		<cfset response.object.call = ARGUMENTS.call>
			
		<cfset this.counter = this.counter -1>
			
		<cfsetting enablecfoutputonly="Yes">
		
		<cfset locals.callmethod = Left( ARGUMENTS.call, Find( " ", ARGUMENTS.call )-1 )>
		<cfset locals.URL = Right( ARGUMENTS.call, Len( ARGUMENTS.call ) - (Find( " ", ARGUMENTS.call )) )>
		
		<cfif Left( ARGUMENTS.call, 1 ) IS "/">
			<cfset ARGUMENTS.call = Right( ARGUMENTS.call, Len( ARGUMENTS.call ) -1 )>
		</cfif>
		
		<!--- Execute the API call --->
		<cfset callURL = this.baseHref & Right( locals.URL, Len( locals.URL )-1 )>

		<cftry>
			<cfhttp url="#callURL#" method="#locals.callmethod#" throwonerror="no" username="#this.apiKey#" password="x">
				<cfif structKeyExists( ARGUMENTS, "body")>
					<cfhttpparam type="body" name="post" encoded="no" value="#ARGUMENTS.body#" />
				<cfelseif structKeyExists( ARGUMENTS, "params")>
					<!--- Pass any values --->
					<cfloop collection="#ARGUMENTS.params#" item="item">
						<cfif item NEQ "APICALLURL" AND item NEQ "APICALLName" AND item NEQ "APIRESULTVIIEWURL">
							<cfhttpparam type="FORMFIELD" name="#item#" value="#params[ item ]#">
						</cfif>
					</cfloop>
				</cfif>
			</cfhttp>

			<cfcatch type="Any">
				
				<cfif this.debug>
					<cfoutput>#outputDebugInfo( ARGUMENTS, response )#</cfoutput>
				</cfif>
				<cfset response.statuscode = cfhttp.Statuscode>
				<cfset response.status = "ERROR">
				<cfreturn response>
			</cfcatch>
		</cftry>
		
		<cfset response.header = cfhttp.Responseheader>
		
		<cfif cfhttp.Statuscode IS NOT "200" AND cfhttp.Statuscode IS NOT "200 OK" AND cfhttp.Statuscode IS NOT "201" AND cfhttp.Statuscode IS NOT "201 Created">
			<cfset response.status = "ERROR">
		</cfif>
		
		<cfif ( cfhttp.Statuscode IS "200 OK" OR cfhttp.Statuscode IS "201" OR cfhttp.Statuscode IS "201 Created" ) AND NOT Find( "cfdump", cfhttp.Filecontent )>
			<cfif cfhttp.Mimetype EQ "text/xml">
				<cftry>
					<cfset response.object = APPLICATION.API.xml2Struct.ConvertXmlToStruct( cfhttp.Filecontent, response.object )>
					<cfcatch type="Any">
						<cfif this.debug>
							<cfoutput>#outputDebugInfo( ARGUMENTS, response )#</cfoutput>
						</cfif>
						
						<cfset response.statuscode = cfhttp.Statuscode>
						<cfset response.status = "ERROR">
						<cfreturn response>
					</cfcatch>
				</cftry>
			<cfelse>
				<cftry>
					<cfset response.object = DeserializeJSON( cfhttp.Filecontent )>
					
					<cfcatch type="Any">
						
						<cfif this.debug>
							<cfoutput>#outputDebugInfo( ARGUMENTS, response )#</cfoutput>
						</cfif>
						
						<cfset response.statuscode = cfhttp.Statuscode>
						<cfset response.status = "ERROR">
						<cfreturn response>
					</cfcatch>
				</cftry>			
			</cfif>
		<cfelse>
			<cfif this.debug>
					<cfoutput>#outputDebugInfo( ARGUMENTS, response )#</cfoutput>
			</cfif>
			<cfset response.statuscode = cfhttp.Statuscode>
			<cfset response.status = "ERROR">
			<cfreturn response>
		</cfif>
		
		<cfif this.debug>
			<cfoutput>#outputDebugInfo( ARGUMENTS, response )#</cfoutput>
		</cfif>
		
		<cfsetting enablecfoutputonly="No">
		
		
		<cfreturn response>
		
	</cffunction>

	<cffunction name="outputDebugInfo">
		<cfargument name="args" required="yes" type="struct">
		<cfargument name="response" required="no" type="struct">
		
		<cfset var parameters = "">
		<cfif StructKeyExists( ARGUMENTS.args, "params" )>
			<cfloop collection="#ARGUMENTS.args.params#" item="item">
				<cfset parameters = parameters & item & "=" & ARGUMENTS.args.params[item] & "&amp;">
			</cfloop>
			<cfset parameters = Left( parameters, (Len( parameters ) -5 ) )>
		</cfif>
		
		
		<cfsavecontent variable="content">
			<cfoutput>
			<style type="text/css">div.dump_#this.counter# { position: absolute; right: 0px; z-index: #this.counter#; }</style>
			<div class="debugContainer" style="position: relative; min-height: 50px; padding: 10px 20px 10px 30px; border-bottom: 1px ##aaa dashed;">
				<div class="dump_#this.counter#">
					<cfdump var="#ARGUMENTS.response#" expand="no">
				</div>
				
				<h3>Call: <span>#ARGUMENTS.args.call#</span></h3>
				<div class="info" >
				<cfif StructKeyExists( ARGUMENTS.args, "body" )>
					<p><b>Body:</b><br /> #ARGUMENTS.args.body#</p>
				</cfif>
				<cfif StructKeyExists( ARGUMENTS.args, "params" )>
					<p ><b>Params:</b><br />#parameters#</p>
				</cfif>
				</div>

				<cfif ARGUMENTS.response.status EQ "OK">
					<div class="status" style="background: ##d5f0d9; font-weight: bold; padding: 2px 4px;">OK</div>
				<cfelse>
					<div class="status" style="background: ##f0d5d5; font-weight: bold; padding: 2px 4px;">ER</div>
				</cfif>
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>
	
	
	<cffunction name="buildRequestBody">
		<cfargument name="wrapper" type="string" required="no" default="body">
		<cfargument name="requestArgs" required="yes">
		<cfargument name="extraWrapper" required="no">
			
		<cfset var body = StructNew()>
		
		<cfif IsStruct( ARGUMENTS.requestArgs )>
			
			<cfloop item="key" collection="#ARGUMENTS.requestArgs#">
				<cfif StructKeyExists( ARGUMENTS.requestArgs,  key )>
					<cfif StructKeyExists( argToEleMap, key )>
						<cfif StructKeyExists( ARGUMENTS, "extraWrapper" )>
							<cfset body["#ARGUMENTS.extraWrapper#"]["#ARGUMENTS.wrapper#"]["#StructFind(argToEleMap, key)#"] = ARGUMENTS.requestArgs[ key ] />
						<cfelse>
							<cfset body["#ARGUMENTS.wrapper#"]["#StructFind(argToEleMap, key)#"] = ARGUMENTS.requestArgs[ key ] />
						</cfif>
					<cfelse>
						<cfif StructKeyExists( ARGUMENTS, "extraWrapper" )>
							<cfset body["#ARGUMENTS.extraWrapper#"]["#ARGUMENTS.wrapper#"]["#key#"] = ARGUMENTS.requestArgs[ key ] />
						<cfelse>
							<cfset body["#ARGUMENTS.wrapper#"]["#key#"] = ARGUMENTS.requestArgs[ key ] />
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset body = this.encodeJson( body )>
		<cfreturn body>
	</cffunction>
	
	
	<!--- CONVERTS DATA FROM CF TO JSON FORMAT --->
	<cffunction name="encodeJson" access="remote" returntype="string" output="No"
			hint="Converts data from CF to JSON format">
		<cfargument name="data" type="any" required="Yes" />
		<!---
			The following argument allows for formatting queries in query or struct format
			If set to query, query will be a structure of colums filled with arrays of data
			If set to array, query will be an array of records filled with a structure of columns
		--->
		<cfargument name="queryFormat" type="string" required="No" default="query" />
		<cfargument name="queryKeyCase" type="string" required="No" default="lower" />
		<cfargument name="stringNumbers" type="boolean" required="No" default=true >
		<cfargument name="formatDates" type="boolean" required="No" default=false >

		
		<!--- VARIABLE DECLARATION --->
		<cfset var jsonString = "" />
		<cfset var tempVal = "" />
		<cfset var arKeys = "" />
		<cfset var colPos = 1 />
		<cfset var i = 1 />
		
		<cfset var _data = arguments.data />

		<!--- NUMBER --->
		<cfif IsNumeric(_data)>
			<cfif ARGUMENTS.stringNumbers EQ false>
				<cfreturn ToString(_data) />
			<cfelse>
				<cfreturn '"' & ToString(_data) & '"' />
			</cfif>

		<!--- BOOLEAN --->
		<cfelseif IsBoolean(_data) AND NOT ListFindNoCase("Yes,No", _data)>
			<cfreturn LCase(ToString(_data)) />
			
		
		<!--- DATE --->
		<cfelseif IsDate(_data) AND arguments.formatDates>
			<cfreturn '"' & APPLICATION.teamworkpm.serverZuluDateFormat( _data ) & '"'>
			<!--- <cfreturn '"#DateFormat(_data, "medium")# #TimeFormat(_data, "medium")#"' />--->
		
		<!--- STRING --->
		<cfelseif IsSimpleValue(_data)>
			<cfreturn '"' & replace( Replace(JSStringFormat(_data), "/", "\/", "ALL"), "\'", "'", "ALL" ) & '"' />
		
		<!--- ARRAY --->
		<cfelseif IsArray(_data)>
			<cfset jsonString = "" />
			<cfloop from="1" to="#ArrayLen(_data)#" index="i">
				<cfset tempVal = encodeJson( _data[i], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates ) />
				<cfset jsonString = ListAppend(jsonString, tempVal, ",") />
			</cfloop>
			
			<cfreturn "[" & jsonString & "]" />
		
		<!--- STRUCT --->
		<cfelseif IsStruct(_data)>
			<cfset jsonString = "" />
			<cfset arKeys = StructKeyArray(_data) />
			<cfloop from="1" to="#ArrayLen(arKeys)#" index="i">
				<cfset tempVal = encodeJson( _data[ arKeys[i] ], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates ) />
				<cfset jsonString = ListAppend(jsonString, '"' & arKeys[i] & '":' & tempVal, ",") />
			</cfloop>
			
			<cfreturn "{" & jsonString & "}" />
		
		<!--- QUERY --->
		<cfelseif IsQuery(_data)>
			<!--- Add query meta data --->
			<cfif arguments.queryKeyCase EQ "lower">
				<cfset recordcountKey = "recordcount" />
				<cfset columnlistKey = "columnlist" />
				<cfset columnlist = LCase(_data.columnlist) />
				<cfset dataKey = "data" />
			<cfelse>
				<cfset recordcountKey = "RECORDCOUNT" />
				<cfset columnlistKey = "COLUMNLIST" />
				<cfset columnlist = _data.columnlist />
				<cfset dataKey = "data" />
			</cfif>
			<cfset jsonString = '"#recordcountKey#":' & _data.recordcount />
			<cfset jsonString = jsonString & ',"#columnlistKey#":"' & columnlist & '"' />
			<cfset jsonString = jsonString & ',"#dataKey#":' />
			
			<!--- Make query a structure of arrays --->
			<cfif arguments.queryFormat EQ "query">
				<cfset jsonString = jsonString & "{" />
				<cfset colPos = 1 />
				
				<cfloop list="#_data.columnlist#" delimiters="," index="column">
					<cfif colPos GT 1>
						<cfset jsonString = jsonString & "," />
					</cfif>
					<cfif arguments.queryKeyCase EQ "lower">
						<cfset column = LCase(column) />
					</cfif>
					<cfset jsonString = jsonString & '"' & column & '":[' />
					
					<cfloop from="1" to="#_data.recordcount#" index="i">
						<!--- Get cell value; recurse to get proper format depending on string/number/boolean data type --->
						<cfset tempVal = encodeJson( _data[column][i], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates ) />
						
						<cfif i GT 1>
							<cfset jsonString = jsonString & "," />
						</cfif>
						<cfset jsonString = jsonString & tempVal />
					</cfloop>
					
					<cfset jsonString = jsonString & "]" />
					
					<cfset colPos = colPos + 1 />
				</cfloop>
				<cfset jsonString = jsonString & "}" />
			<!--- Make query an array of structures --->
			<cfelse>
				<cfset jsonString = jsonString & "[" />
				<cfloop query="_data">
					<cfif CurrentRow GT 1>
						<cfset jsonString = jsonString & "," />
					</cfif>
					<cfset jsonString = jsonString & "{" />
					<cfset colPos = 1 />
					<cfloop list="#columnlist#" delimiters="," index="column">
						<cfset tempVal = encodeJson( _data[column][CurrentRow], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates ) />
						
						<cfif colPos GT 1>
							<cfset jsonString = jsonString & "," />
						</cfif>
						
						<cfif arguments.queryKeyCase EQ "lower">
							<cfset column = LCase(column) />
						</cfif>
						<cfset jsonString = jsonString & '"' & column & '":' & tempVal />
						
						<cfset colPos = colPos + 1 />
					</cfloop>
					<cfset jsonString = jsonString & "}" />
				</cfloop>
				<cfset jsonString = jsonString & "]" />
			</cfif>
			
			<!--- Wrap all query data into an object --->
			<cfreturn "{" & jsonString & "}" />
		
		<!--- UNKNOWN OBJECT TYPE --->
		<cfelse>
			<cfreturn '"' & "unknown-obj" & '"' />
		</cfif>
	</cffunction>
</cfcomponent>