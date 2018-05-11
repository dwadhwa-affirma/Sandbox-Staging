<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OpsServices_Send_Member_Email_Confirmation_Spectrum</fullName>
        <description>OpsServices Send Member Email Confirmation - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/OpsServices_Secure_Portal_Case_Spectrum</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Confirmation_CFCU</fullName>
        <description>Send Member Email Confirmation - CFCU</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@chevronfcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Case_Confirmation_CFCU</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Confirmation_Spectrum</fullName>
        <description>Send Member Email Confirmation - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Case_Confirmation_Spectrum</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_Case_to_EPS_Queue</fullName>
        <description>Assign Case to EPS Queue</description>
        <field>OwnerId</field>
        <lookupValue>EPS_Card_Services_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to EPS Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_MC_Que</fullName>
        <field>OwnerId</field>
        <lookupValue>eBranch_Member_Communications</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to MC Que</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Survey_Case_to_Queue</fullName>
        <field>Ownership_ID__c</field>
        <name>Assign Survey Case to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Death_Claims_Queue</fullName>
        <description>Field Update to Assign &quot;Open&quot; Death Claims cases to &quot;Death Claim&quot; Queues</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Death_Claims</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Death Claims&quot; Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_EPS_Research_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>EPS_Card_Services_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;EPS Research&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Inactive_Escheatment_Queue</fullName>
        <description>Assigns the case to Operations-Inactive Notices&amp;Escheatments Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Inactive_Notices_Escheatments</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Inactive/Escheatment&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Marketing_Queue</fullName>
        <description>Assigns record to the Marketing queue</description>
        <field>OwnerId</field>
        <lookupValue>Marketing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Marketing&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Online_Banking_Queue</fullName>
        <description>Field update that assigns the case to Operations-Online &amp; Mobile Banking Queue</description>
        <field>OwnerId</field>
        <lookupValue>eBranch_Online_Mobile_Banking</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Online Banking&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Online_Bnkng_Holds_Apprvl_Que</fullName>
        <description>Assign Release Check Holds (Cases) to the e-Deposits-ReleaseCheckHoldsApprvl Queue</description>
        <field>OwnerId</field>
        <lookupValue>e_Deposits_Release_Check_Holds_Apprvl</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Online Bnkng Holds Apprvl Que</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Operations_Memberships_Queue</fullName>
        <description>Field update to assign the case to Operations-Memberships Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Memberships</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Operations-Memberships&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ops_Domestic_Wires_Queue</fullName>
        <description>Field Update to assign the case to Operations-Others Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Domestic_Wires</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Ops-Domestic Wires&quot; Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ops_Foriegn_Wire_Queue</fullName>
        <description>Field Update to assign the case to Operations-Foriegn Wire Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Foriegn_Wire</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Ops-Foriegn Wire&quot; Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ops_IRA_HSA_Queue</fullName>
        <description>Assign to &quot;Ops-IRA/HSA&quot; Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_IRA_HSA</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Ops-IRA/HSA&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ops_Levies_Queue</fullName>
        <description>Assigns cases to the Levies queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Levies</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Ops - Levies&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ops_Other_Queue</fullName>
        <description>Field Update to assign the case to Operations-Others Queue</description>
        <field>OwnerId</field>
        <lookupValue>Operations_Others</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to &quot;Ops-Other&quot; Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Operations_Memberships</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_in_process</fullName>
        <field>Status</field>
        <literalValue>In Process</literalValue>
        <name>Change Status in process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DocuSign_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>DocuSign_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>DocuSign Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DocuSign_Waiting_Status</fullName>
        <field>Status</field>
        <literalValue>Waiting for a member</literalValue>
        <name>DocuSign Waiting Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Edit_Status</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day2 Started</literalValue>
        <name>Edit Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_14_Sub_Status</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day14 Started</literalValue>
        <name>Onboarding Day 14 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_14_Sub_Status1</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day14 Started</literalValue>
        <name>Onboarding Day 14 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_1_Status1</fullName>
        <field>Status</field>
        <literalValue>Follow Up</literalValue>
        <name>Onboarding Day 1 Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_1_Sub_Status</fullName>
        <description>Onboarding Day 1 Sub Status</description>
        <field>Sub_Status__c</field>
        <literalValue>Day1 Started</literalValue>
        <name>Onboarding Day 1 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_1_Sub_Status1</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day1 Started</literalValue>
        <name>Onboarding Day 1 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_25_Sub_Status</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day25 Started</literalValue>
        <name>Onboarding Day 25 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_25_Sub_Status1</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day25 Started</literalValue>
        <name>Onboarding Day 25 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_2_Sub_Status</fullName>
        <description>Set the sub status = Day 2 Started</description>
        <field>Sub_Status__c</field>
        <literalValue>Day2 Started</literalValue>
        <name>Onboarding Day 2 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_2_Sub_Status1</fullName>
        <description>Set the sub status = Day 2 Started</description>
        <field>Sub_Status__c</field>
        <literalValue>Day2 Started</literalValue>
        <name>Onboarding Day 2 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_60_Sub_Status</fullName>
        <description>Onboarding Day 60 Sub Status</description>
        <field>Sub_Status__c</field>
        <literalValue>Day60 Started</literalValue>
        <name>Onboarding Day 60 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_60_Sub_Status1</fullName>
        <description>Onboarding Day 60 Sub Status</description>
        <field>Sub_Status__c</field>
        <literalValue>Day60 Started</literalValue>
        <name>Onboarding Day 60 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_90_Sub_Status</fullName>
        <description>Onboarding Day 90 Sub Status</description>
        <field>Sub_Status__c</field>
        <literalValue>Day90 Started</literalValue>
        <name>Onboarding Day 90 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onboarding_Day_90_Sub_Status1</fullName>
        <description>Onboarding Day 90 Sub Status</description>
        <field>Sub_Status__c</field>
        <literalValue>Day90 Started</literalValue>
        <name>Onboarding Day 90 Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secure_Portal_Case_Set_Origin</fullName>
        <field>Origin</field>
        <literalValue>Portal</literalValue>
        <name>Secure Portal - Case Set Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secure_Portal_Case_Set_Record_Type</fullName>
        <description>Set the record type for new portal created cases to &quot;Portal&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Portal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Secure Portal - Case Set Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secure_Portal_Case_set_Case_Num</fullName>
        <description>This action strips leading zeros and sets the case num field in the Case.</description>
        <field>Case_Num__c</field>
        <formula>TEXT(VALUE( CaseNumber ))</formula>
        <name>Secure Portal - Case set Case Num</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secure_Portal_Case_set_Member_Num</fullName>
        <description>This action sets the member num field in the Case to bypass a Process builder limitation</description>
        <field>Member_Num__c</field>
        <formula>TEXT(VALUE(Account_Number__r.Name))</formula>
        <name>Secure Portal - Case set Member Num</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalated_Flag_Off</fullName>
        <field>IsEscalated</field>
        <literalValue>0</literalValue>
        <name>Set Escalated Flag Off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalated_Flag_On</fullName>
        <description>Set the Escalated flag field to TRUE</description>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Set Escalated Flag On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SLATemp</fullName>
        <field>SLATemp__c</field>
        <literalValue>1</literalValue>
        <name>Set SLATemp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_In_Process</fullName>
        <field>Status</field>
        <literalValue>In Process</literalValue>
        <name>Set Status to In Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Open</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Set Status to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status</fullName>
        <field>Status</field>
        <literalValue>Follow Up</literalValue>
        <name>Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_1</fullName>
        <field>Status</field>
        <literalValue>Follow Up</literalValue>
        <name>Status - 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_status</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day1 Started</literalValue>
        <name>Sub status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_status_1</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Day1 Started</literalValue>
        <name>Sub status 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Turn_off_Send_Secure_Email_Flag</fullName>
        <field>Send_Secure_Email__c</field>
        <literalValue>0</literalValue>
        <name>Turn off Send Secure Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseOwnertoMemCommQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>eBranch_Member_Communications</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateCaseOwnertoMemCommQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_5_Day_Flag_to_False</fullName>
        <description>Field Update to Set &quot;Five Day Flag&quot; to &quot;False&quot;</description>
        <field>Five_Day_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Update 5 Day Flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_5_Day_Flag_to_True</fullName>
        <description>This field update updated &quot;Five Day Flag&quot; to &quot;True&quot;</description>
        <field>Five_Day_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update 5 Day Flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Servicing_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Operation_Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account Servicing Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Death_Claims_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Death_Claims</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Death Claims Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Levy_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Levies</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Levy Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Portal_Record_Type</fullName>
        <description>Set the initial record type to &quot;Portal&quot; for member created portal cases</description>
        <field>RecordTypeId</field>
        <lookupValue>Portal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Portal Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_eBanking_Check_Hold_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>eBanking_Check_Hold</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update eBanking Check Hold Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>subject_change</fullName>
        <field>Subject</field>
        <formula>Catagory__c</formula>
        <name>Subject change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Maintenance - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
            <value>Levy,Death Claims</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Category__c</field>
            <operation>notEqual</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account Maintenance - Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Online Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
            <value>Release Hold,Levy,Death Claims</value>
        </criteriaItems>
        <description>Primary = Account Maintenance, Tertiary not (Release Hold, Levy, Death Claim)
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22Domestic Wires%22</fullName>
        <actions>
            <name>Assign_to_Ops_Domestic_Wires_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Workflow to assign an &quot;Open&quot; Domestic Wires cases to the Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           CONTAINS( Category__c , &apos;Domestic Wires&apos;),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22Foreign Wires%22</fullName>
        <actions>
            <name>Assign_to_Ops_Foriegn_Wire_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Workflow to assign an &quot;Open&quot; Foreign Wires cases to the Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           CONTAINS( Category__c , &apos;Foreign Wires&apos;),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22IRA%2FHSA%22</fullName>
        <actions>
            <name>Assign_to_Ops_IRA_HSA_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Assign Open &quot;IRA/HSA&quot; Case</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           OR ( CONTAINS( Category__c , &apos;IRA&apos;),               CONTAINS( Category__c , &apos;HSA&apos;)              ),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22Inactive%2FEscheatment%22</fullName>
        <actions>
            <name>Assign_to_Inactive_Escheatment_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Workflow to assign an &quot;Open&quot; Inactive/Escheatment cases to the Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           CONTAINS( Category__c , &apos;Inactive Notices&apos;),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22Membership%22</fullName>
        <actions>
            <name>Assign_to_Operations_Memberships_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Workflow to assign an &quot;Open&quot; Membership cases to the Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           CONTAINS( Category__c , &apos;Membership&apos;),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Open to Queue - %22OPS Other%22</fullName>
        <actions>
            <name>Assign_to_Ops_Other_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Operation Services&apos; - Assign Open &quot;OPS Others&quot; Case Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           OR ( CONTAINS( Category__c , &apos;Ops Other&apos;),               CONTAINS( Category__c , &apos;Checks,Tax&apos;),               CONTAINS( Category__c , &apos;Forms&apos;),               CONTAINS( Category__c , &apos;Official Checks&apos;),               CONTAINS( Category__c , &apos;Address Change&apos;),               CONTAINS( Category__c , &apos;Close Account&apos;),               CONTAINS( Category__c , &apos;Shared Certificates&apos;)              ),          TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Branch Research - Open - Escalation</fullName>
        <active>false</active>
        <description>Shared Branch - &quot;Cat contains &apos;Branch Research&quot;&quot; and 
Status = &apos;Open&apos; and 
created by user&apos;s profile contains &apos;Branch&apos;&quot; or &quot;Call Center&quot; and
Elapsed time is x hours</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Location&apos;),                TEXT(Status) = &apos;Open&apos;,               OR(CONTAINS(CreatedBy.Profile.Name, &apos;Branch&apos;),                  CONTAINS(CreatedBy.Profile.Name, &apos;Call Center&apos;))              ) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Card Services -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Card Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Primary = Card Services
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Card Services - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Card Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - In Process - Set Escalation Off</fullName>
        <actions>
            <name>Set_Escalated_Flag_Off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When Escalated = &apos;TRUE&apos; and Status gets set to &apos;Closed&apos;, turn off the escalation flag</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Death Claim - Open</fullName>
        <actions>
            <name>Assign_to_Death_Claims_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&apos;Death Claims&apos; - Workflow kicks in whenever the Status of the Death Claims Cases is equal to &apos;Open&apos;</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Death Claim&apos;),           TEXT(Status) = &apos;Open&apos;         ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Death Claims - Active - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>contains</operation>
            <value>Death Claim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>&apos;Death Claims&apos; - Case is in any active status after 60 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DocuSign Sent</fullName>
        <actions>
            <name>DocuSign_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DocuSign_Waiting_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Docusign_Envelope_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EPS - Open - Set Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>contains</operation>
            <value>Location</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Shared Branch - Cat contains &apos;EPS&apos; and 
Status = &apos;Open&apos; and
elapsed time = x business hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Holds - Open - Escalation</fullName>
        <active>false</active>
        <description>&quot;Cat contains &apos;Release Holds&apos; and 
Status = &apos;Open&apos; and 
created by user&apos;s profile contains &apos;Branch&apos; or &apos;Call Center&apos; and
Elapsed time is x hours</description>
        <formula>IF(    AND(CONTAINS(Category__c, &apos;Release Hold&apos;),        TEXT(Status) = &apos;Open&apos;,        OR(CONTAINS(CreatedBy.Profile.Name, &apos;Branch&apos;),           CONTAINS(CreatedBy.Profile.Name, &apos;Call Center&apos;)        )    ),    true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Inquires -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Inquires</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notContain</operation>
            <value>Branch Locations,ATM Locations</value>
        </criteriaItems>
        <description>Primary = Inquires, Tertiary not (Branch Locations, ATM Locations)
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Inquiries - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Inquires</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lending -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Lending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Primary = Lending
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lending - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Lending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Levies - Active - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>contains</operation>
            <value>Levy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Cat contains &apos;Levy&apos; and 
Status is not &apos;Open&apos; or &apos;Closed&apos; and
Status changed from &apos;Open&apos; = 10 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Levies - Open</fullName>
        <actions>
            <name>Assign_to_Ops_Levies_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Levies</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Levy&apos;),           TEXT(Status) = &apos;Open&apos;,           Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Levies - Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>contains</operation>
            <value>Levy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Cat contains &apos;Levy&apos; and 
Status = &apos;Open&apos; and
elapsed time = x business hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MC Case Catchall</fullName>
        <actions>
            <name>Assign_to_Marketing_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Marketing Cloud</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>SFMC Integration User</value>
        </criteriaItems>
        <description>Looks for cases created by the Marketing Cloud that did not get assigned to the related account&apos;s Episys user.  When found, the cases are to be routed to the Marketing queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mobile Banking -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Mobile Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Primary = Mobile Banking
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Moble Banking - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Mobile Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 1 day</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_1_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Onboarding_Day_1_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Send_Day_1_Welcome_Email_to_Member1</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 10 - Mins</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Sub_status_1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>test</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 14 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_14_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Perform_Day_14_Follow_Up_Call_With_New_Member1</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 2 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_2_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Send_Day_2_Thank_You_Card_to_Member1</name>
                <type>Task</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 4 hr</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_25_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Send_Day_25_Email_To_New_Member1</name>
                <type>Task</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 6 hr</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_90_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Perform_Onboarding_90_Day_Follow_Up_Call1</name>
                <type>Task</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Onboarding 60 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Day_60_Sub_Status1</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Perform_Day_60_Follow_Up_Call_With_New_Member1</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Online Banking -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Online Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Primary = Online Banking
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Online Banking - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Online Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Online Banking - Open</fullName>
        <actions>
            <name>Assign_to_Online_Banking_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign an &quot;Open&quot; Online Banking cases to the Queue</description>
        <formula>IF(      AND( CONTAINS(Category__c, &apos;Account Servicing&apos;),           OR ( CONTAINS( Category__c , &apos;Online Banking&apos;),               CONTAINS( Category__c , &apos;ATM/Debit Cards&apos;),               CONTAINS( Category__c , &apos;Mobile Banking&apos;)              ),          TEXT(Status) = &apos;Open&apos;,           NOT(CONTAINS( CreatedBy.UserRole.Name , &apos;Member_Comm&apos;)),          Account_Number__c  &lt;&gt;  &apos;&apos;          ), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Operations - Closed - Member - Spectrum</fullName>
        <active>false</active>
        <description>Workflow kicks in whenever the Status of the Operation&apos;s Case is equal to Closed</description>
        <formula>IF(     AND( TEXT(Status) = &apos;Closed&apos;,         TEXT(Brand_Code__c) = &apos;BC02&apos;,         OR (CONTAINS(Category__c, &apos;Inactive Notices &amp; Escheatment&apos;),             CONTAINS(Category__c, &apos;Fee Reversal&apos;),             CONTAINS(Category__c, &apos;Subpoenas&apos;),             CONTAINS(Category__c, &apos;Ops Other&apos;),             CONTAINS(Category__c, &apos;Checks&apos;),             CONTAINS(Category__c, &apos;Tax Forms&apos;),             CONTAINS(Category__c, &apos;ATM/Debit Cards&apos;),             CONTAINS(Category__c, &apos;Online Banking&apos;),             CONTAINS(Category__c, &apos;Mobile Banking&apos;),             CONTAINS(Category__c, &apos;Wires&apos;),             CONTAINS(Category__c, &apos;Official Checks&apos;),             CONTAINS(Category__c, &apos;Address Change&apos;),             CONTAINS(Category__c, &apos;Close Account&apos;),             CONTAINS(Category__c, &apos;Membership&apos;),             CONTAINS(Category__c, &apos;IRA&apos;),             CONTAINS(Category__c, &apos;HSA&apos;),             CONTAINS(Category__c, &apos;Shared Certificates&apos;),             CONTAINS(Category__c, &apos;W8 Forms&apos;),             CONTAINS(Category__c, &apos;W9 Forms&apos;),             CONTAINS(Category__c, &apos;Stop Payment&apos;)            )           ) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Portal Set Record Type - Account Servicing</fullName>
        <actions>
            <name>Update_Account_Servicing_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
            <value>Levy,Death Claims</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Reset the Portal Case record type to Account Servicint</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Portal Set Record Type - Death Claims</fullName>
        <actions>
            <name>Update_Death_Claims_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>equals</operation>
            <value>Death Claims</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Reset the Portal Case record type to Death Claims</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Portal Set Record Type - Levy</fullName>
        <actions>
            <name>Update_Levy_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>equals</operation>
            <value>Levy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notContain</operation>
        </criteriaItems>
        <description>Reset the Portal Case record type to Levy</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Portal Set Record Type - Portal</fullName>
        <actions>
            <name>Update_Portal_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Reset the Portal Case record type to Portal</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Secure Portal Case - Assign</fullName>
        <actions>
            <name>Assign_Case_to_MC_Que</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assigns secure portal cases (Member Created) to the appropriate queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Secure Portal Case Creation</fullName>
        <actions>
            <name>Secure_Portal_Case_Set_Origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Secure_Portal_Case_set_Case_Num</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Secure_Portal_Case_set_Member_Num</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This Portal workflow is used as follows. 
1. Populate the related Account Number into the Member_Num__c field. 
2. Strip/Populate the case num field.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Secure Email - Member - CFCU</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Brand_Code__c</field>
            <operation>equals</operation>
            <value>BC01</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Send_Secure_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Turn_off_Send_Secure_Email_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Assigned Cases to In Progress</fullName>
        <actions>
            <name>Set_Status_to_In_Process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Branch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Portal</value>
        </criteriaItems>
        <description>Set Assigned Cases to In Progress</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Assigned Portal Case Status</fullName>
        <actions>
            <name>Change_Status_in_process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.FlowTimeSet__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Category__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>set assigned portal cases status in process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Portal Cases to Open</fullName>
        <actions>
            <name>Set_Status_to_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Portal Cases to Open</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Shared Branching - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Shared Branching</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Survey Response Case</fullName>
        <actions>
            <name>Assign_Survey_Case_to_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Email,Phone,Web</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Test Task</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>Rana Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Edit_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Test_Task_Count</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Transactions -  Open - Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Transactions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Primary = Transaction
Status = Open and 1 Day after Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Transactions - Active - 2 Day Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Transactions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Open</value>
        </criteriaItems>
        <description>Case is in any active status but Open and has been in progress/active for 2 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Escalated_Flag_On</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Account Servicing Record Type</fullName>
        <actions>
            <name>Update_Account_Servicing_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Account Maintenance,Online Banking,Lending,Inquires,Transactions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email2Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>notEqual</operation>
            <value>Death Claims</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Death Claims Record Type</fullName>
        <actions>
            <name>Update_Death_Claims_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>equals</operation>
            <value>Death Claims</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email2Case</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Levy Record Type</fullName>
        <actions>
            <name>Update_Levy_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tertiary_Category__c</field>
            <operation>equals</operation>
            <value>Levy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email2Case</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update eBanking Check Hold Record Type</fullName>
        <actions>
            <name>Update_eBanking_Check_Hold_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Primary_Category__c</field>
            <operation>equals</operation>
            <value>Mobile Banking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email2Case</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCaseOwnertoMemCommQueue</fullName>
        <actions>
            <name>UpdateCaseOwnertoMemCommQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved for MCS,Updated for MCS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Notify_Member_EPS_Research_Complete</fullName>
        <assignedToType>creator</assignedToType>
        <description>The EPS Research case is complete.  Please email or notify the member regarding the outcome.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Notify Member - EPS Research Complete</subject>
    </tasks>
    <tasks>
        <fullName>Notify_Member_Holds_Branch_Research_Complete</fullName>
        <assignedToType>creator</assignedToType>
        <description>Your Holds / Branch Research case has been completed. Please notify the member of the case outcome.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Notify Member - Holds / Branch Research Complete</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Day_14_Follow_Up_Call_With_New_Member</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Day 14 Follow Up Call With New Member</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Day_14_Follow_Up_Call_With_New_Member1</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Day 14 Follow Up Call With New Member</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Day_60_Follow_Up_Call_With_New_Member</fullName>
        <assignedToType>owner</assignedToType>
        <description>Perform the Onboarding 60 day follow up with the new member</description>
        <dueDateOffset>65</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Day 60 Follow Up Call With New Member</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Day_60_Follow_Up_Call_With_New_Member1</fullName>
        <assignedToType>owner</assignedToType>
        <description>Perform the Onboarding 60 day follow up with the new member</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Day 60 Follow Up Call With New Member</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Onboarding_90_Day_Follow_Up_Call</fullName>
        <assignedToType>owner</assignedToType>
        <description>Perform Onboarding 90 Day Follow Up Call</description>
        <dueDateOffset>95</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Onboarding 90 Day Follow Up Call</subject>
    </tasks>
    <tasks>
        <fullName>Perform_Onboarding_90_Day_Follow_Up_Call1</fullName>
        <assignedToType>owner</assignedToType>
        <description>Perform Onboarding 90 Day Follow Up Call</description>
        <dueDateOffset>95</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Perform Day 90 Follow Up Call With New Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_0_10_Letter_to_Member</fullName>
        <assignedToType>owner</assignedToType>
        <description>Test</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 0 10 Letter to Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_1_Welcome_Email_to_Member</fullName>
        <assignedToType>creator</assignedToType>
        <description>Send the Onboarding &quot;Day 1 Welcome Email&quot; to the new member</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 1 Welcome Email to Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_1_Welcome_Email_to_Member1</fullName>
        <assignedToType>owner</assignedToType>
        <description>Send the Onboarding &quot;Day 1 Welcome Email&quot; to the new member</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 1 Letter to Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_25_Email_To_New_Member</fullName>
        <assignedToType>owner</assignedToType>
        <description>Send the Onboarding Day 25 email to the new member reminding them of the digital services the CU provides.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 25 Email To New Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_25_Email_To_New_Member1</fullName>
        <assignedToType>owner</assignedToType>
        <description>Send the Onboarding Day 25 email to the new member reminding them of the digital services the CU provides.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 25 Email To New Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_2_Thank_You_Card_to_Member</fullName>
        <assignedToType>owner</assignedToType>
        <description>Send the Onboarding Day 2 Thank You card to the new member</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 2 Thank You Card to Member</subject>
    </tasks>
    <tasks>
        <fullName>Send_Day_2_Thank_You_Card_to_Member1</fullName>
        <assignedToType>owner</assignedToType>
        <description>Send the Onboarding Day 2 Thank You card to the new member</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Day 2 Thank You Card to Member</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task_Count</fullName>
        <assignedTo>drana@chevronfcu.org</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Check</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Test Task Count</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task_Count1</fullName>
        <assignedTo>drana@chevronfcu.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Test Task Count1</subject>
    </tasks>
    <tasks>
        <fullName>test</fullName>
        <assignedToType>owner</assignedToType>
        <description>asdfasdfafda</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>test</subject>
    </tasks>
</Workflow>
