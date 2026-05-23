# Server
## Categories based on group 
1. Create a Group
2. edit group and past this:
```xml
<agent_config>
       <labels>
               <label key="group">Team_A</label>
       </labels>
       
       <localfile>
           <location>Microsoft-Windows-Windows/Operational</location>
           <log_format>eventchannel</log_format>
       </localfile>
</agent_config>
```
