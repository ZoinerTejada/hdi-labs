# HDInsight Labs

The following labs are currently available, before attempting any of the labs be sure you have followed the instructions in Lab Setup. When you are done with the labs, be sure to follow the instructions under Cleanup to delete your lab environment and avoid uneeded costs.

## Setup
### [Lab Setup](Setup/Environment-Setup.md): 
Follow the steps in this section to setup your environment to complete the labs.

## Labs
### [Lab 1 - Batch & ETL Processing of Big Data with Spark SQL](Labs/Lab01/Lab01.md): 
AdventureWorks is an e-commerce retailer who is looking to improve how they manage the data assets produced by their platform. As a starting point they would like collect their data in a manner that enables easier exploration and prepares the data for downstream analytics processes that can yield new insights. Adventurworks has asked you to process and prepare their flat file data into a tabular format that offers better query perfomrance and can be queried using SQL.

In the lab you will learn how to use Spark SQL (and PySpark) to batch process a 10GB text file dataset, quickly explore its content, identify issues with the data, clean and format the data and load it into Hive tables to support downstream analytics.

### [Lab 2 - Data Warehouse / Interactive Pattern - Interactive Querying with Spark, LLAP and Power BI](Labs/Lab02/Lab02.md):
AdventureWorks would like to create some visualizations of their data to better understand their customers. They are interested in using the powerful visualization capabilities of Power BI and its ability to allow them to share those visualizations, but aren't sure how they can pull in the data to create the dashboards.

They have provided all the weblogs and user tables that you can use to quickly explore the data, and have the product information available in flat files. You will prepare the data to be used in Power BI, explore the data using Spark SQL and Jupyter's built-in visualizations, as well as Matplotlib for more advanced control. You will also run these same interactive queries on an LLAP cluster against the same data to see if there is any performance benefit. Finally, you will import the data into Power BI to create interactive dashboards and reports.

### [Lab 3 - Data Science using Spark](Labs/Lab03/Lab03.md):
AdventureWorks would like to add a snazzy product recommendations feature to their website and email marketing campaigns that, for every user in their system, can recommend the top 10 products they might be interested in purchasing. Adventureworks has provided you with the tables for users, products and weblogs that contains all of the data you need.

In this lab, you will train a recommendation model using Spark's built-in collaborative filtering alogrithm - Alternating Least Squares (ALS). Then you will use the model to pre-compute the user to product recommendation for every user and save this in a table. Then you will query from this table to quickly get the 10 product recommendations for a given user.

### [Lab 4 - Streaming Pattern: Processing events from Kafka using Spark and MLlib](Labs/Lab04/Lab04.md):
AdventureWorks has asked for the ability to extend their product recommendations feature, integrating the trained Alternating Least Squares (ALS) recommendation model to make predictions against streaming weblog data from Kafka.

In this lab, you will upload and run a Java .jar application to add sample weblog data into a Kafka topic, and use the same application to view the data added. You will then create a simple Kafka producer using Spark to add a few more records to the topic. Next, you will use Spark Structured Streaming to query the data, and run the streamed data against the ALS recommendation model, getting product recommendations for a given user.

### [Lab 5 - Monitoring & Configuration](Labs/Lab05/Lab05.md)
AdventureWorks would like to monitor the health and performance of their HDInsight cluster, which is essential for maintaining maximum performance and resource utilization. They would like to be able to address possible coding or cluster configuration errors, through monitoring. They are also interested in being proactive with addressing potential issues by being alerted when certain events occur, such as a failing app.

To meet their requirements, you will enable Azure Log Analytics in Operations Manager Suite (OMS) to monitor their cluster's operations. You will demonstrate how to query the cluster's logs for errors or other events, and set up alerts based on those queries. Also, you will use the YARN and Spark UIs to track applications, and use the Spark History Server to view the history of the applications. Finally, you will use Ambari to configure Spark settings.

### [Lab 6: Securing the Environment](Labs/Lab06/Lab06.md)
AdventureWorks has set up an [Azure Active Directory (AAD)](https://docs.microsoft.com/azure/active-directory/active-directory-whatis) domain, and has added user accounts and roles for employees to use when working with data. They want to make sure that sensitive information, such as user birthdates and passwords, is only accessible to admin-level employees. They have created a [domain-joined HDInsight Spark cluster](https://docs.microsoft.com/azure/hdinsight/hdinsight-domain-joined-configure) within a VNet, and joined to their AAD domain. Now they want to properly set up permissions to restrict access to certain data when users log in to Zeppelin to run queries, or generate reports from this data in Power BI.

Domain-joined HDInsight clusters take advantage of strong authentication with Azure Active Directory users, as well as use role-based access control (RBAC) policies for various services, such as YARN and Hive. In this lab, you will view the users and groups synchronized from AAD in Ambari, use Ranger to control access to Hive tables, as well as configure data masks and row level filters. Finally, you will connect to your cluster's Hive tables in Power BI and observe the permissions being applied there.

### [Lab 7 - Extending the cluster with HDInsight Applications](Labs/Lab07/Lab07.md):
AdventureWorks is interested in using HDInsight applications for extending the capabilities their cluster. They are interested in two applications, H2O Sparkling Water and Apache Solr. H2O will provide machine learning and predictive analytics, while Solr will provide enterprise search capabilities.

They have provided you with the tables for users, products, and weblogs that contain all the data you need. You will build and train a deep learning model using H2O Sparkling Water, combining the capabilities of Spark with H2O. Then, you will use Solr to add search capabilities to the AdventureWorks cluster.

In this lab you will learn how to extend an existing HDInsight cluster by installing both third-party and custom applications.

## Cleanup
### [Lab Cleanup](Setup/Environment-Cleanup.md): 
When you are done with the labs be sure to follow these instructions to cleanup your Azure subscription and avoid unnecessary costs.

