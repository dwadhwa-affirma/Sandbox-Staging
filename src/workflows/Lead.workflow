<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_Assigned_to_LO_Notify_LO_and_Manager</fullName>
        <description>Lead - Assigned to LO - Notify LO and Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>Lending_Sales_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Mortgage_Loan_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Leads/Lead_Open_Assigned_To_LO_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>DescriptionUpdate</fullName>
        <field>Description__c</field>
        <formula>IF(ISBLANK(Description),  &apos;&apos;, Description)</formula>
        <name>DescriptionUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalate_Lead</fullName>
        <description>Escalate the Lead if Unassigned within 24 hours</description>
        <field>Escalated__c</field>
        <literalValue>1</literalValue>
        <name>Escalate Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalate_unclosed_Lead</fullName>
        <description>Escalate assigned unclosed Lead</description>
        <field>Escalated__c</field>
        <literalValue>1</literalValue>
        <name>Escalate unclosed Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_To_Queue</fullName>
        <description>Assign the lead to the RE Referral queue</description>
        <field>OwnerId</field>
        <lookupValue>Real_Estate_Referrals</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead - To Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_in_process</fullName>
        <field>Status</field>
        <literalValue>In Process</literalValue>
        <name>Set Lead Status to in Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Escalated</fullName>
        <field>Escalated__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change assigned lead status</fullName>
        <actions>
            <name>Set_Lead_Status_to_in_process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <description>Assigned lead status to in process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DeEscalate Lead</fullName>
        <actions>
            <name>Uncheck_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Escalated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Over72_hours__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Description Update</fullName>
        <actions>
            <name>DescriptionUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalate Unassigned Lead</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <description>Unassigned to a rep within 24 hours - Escalated</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Escalate_Lead</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Escalate unclosed Lead at 72 hours</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Assigned lead and status except closed within 72 hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Escalate_unclosed_Lead</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
