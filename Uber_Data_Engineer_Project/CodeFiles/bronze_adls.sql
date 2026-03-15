-- Databricks notebook source
-- DBTITLE 1,Cell 1
-- MAGIC %python
-- MAGIC import pandas as pd
-- MAGIC
-- MAGIC url="https://dlcabprojectdev.blob.core.windows.net/raw/ingestion/map_cities.json?sp=r&st=2026-03-05T21:08:28Z&se=2027-07-28T05:23:28Z&spr=https&sv=2024-11-04&sr=c&sig=ybWnQMhL5JkZcK7jtBklgde8k%2Bwec4hq1gjbxSlHVEs%3D"
-- MAGIC df = pd.read_json(url)
-- MAGIC df_spark=spark.createDataFrame(df)
-- MAGIC display(df)
-- MAGIC

-- COMMAND ----------

-- DBTITLE 1,Untitled
-- MAGIC %python
-- MAGIC import pandas as pd
-- MAGIC
-- MAGIC files = [
-- MAGIC {"file":"map_cities"},
-- MAGIC {"file":"map_cancellation_reasons"},
-- MAGIC {"file":"map_payment_methods"},
-- MAGIC {"file":"map_ride_statuses"},
-- MAGIC {"file":"map_vehicle_makes"},
-- MAGIC {"file":"map_vehicle_types"}
-- MAGIC ]
-- MAGIC
-- MAGIC for file in files:
-- MAGIC
-- MAGIC     url = f"https://dlcabprojectdev.blob.core.windows.net/raw/ingestion/{file['file']}.json?sp=r&st=2026-03-05T21:08:28Z&se=2027-07-28T05:23:28Z&spr=https&sv=2024-11-04&sr=c&sig=ybWnQMhL5JkZcK7jtBklgde8k%2Bwec4hq1gjbxSlHVEs%3D"
-- MAGIC
-- MAGIC     df = pd.read_json(url)
-- MAGIC     df_spark = spark.createDataFrame(df)
-- MAGIC     
-- MAGIC     # Writing Data To the Bronze Layer
-- MAGIC     df_spark.write.format("delta")\
-- MAGIC             .mode("overwrite")\
-- MAGIC             .option("overwriteSchema", "true")\
-- MAGIC             .saveAsTable(f"uber.bronze.{file['file']}")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC url = "https://dlcabprojectdev.blob.core.windows.net/raw/ingestion/bulk_rides.json?sp=r&st=2026-03-05T21:08:28Z&se=2027-07-28T05:23:28Z&spr=https&sv=2024-11-04&sr=c&sig=ybWnQMhL5JkZcK7jtBklgde8k%2Bwec4hq1gjbxSlHVEs%3D"
-- MAGIC
-- MAGIC df = pd.read_json(url)
-- MAGIC df_spark = spark.createDataFrame(df)
-- MAGIC if not spark.catalog.tableExists("uber.bronze.bulk_rides"):
-- MAGIC     df_spark.write.format("delta")\
-- MAGIC             .mode("overwrite")\
-- MAGIC             .saveAsTable(f"uber.bronze.bulk_rides")
-- MAGIC     print("This will not run more than 1 time")

-- COMMAND ----------

SELECT * FROM uber.bronze.map_cities

-- COMMAND ----------

