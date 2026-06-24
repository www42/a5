# Guided project: Build a simple website endpoint with Azure Functions

## Exercise 1: Create the Function App

### Task 1: Prepare the environment

Set up your Azure environment before you begin. You create a resource group to organize all the resources for this project together.

### Task 2: Configure the Function App

Set up the Function App with serverless hosting. The Flex Consumption plan ensures you pay only for the execution time of your functions, making it cost-effective for occasional workloads.

### Task 3: Verify the deployment

Confirm that your Function App deployed successfully and is running.




## Exercise 2: Deploy an HTTP-trigger function

### Task 1: Open Cloud Shell

Launch Azure Cloud Shell so you can use the command line to create and deploy a function.

### Task 2: Create the function project

Use the Azure Functions Core Tools in Cloud Shell to scaffold a new function project with an HTTP trigger.

At the Cloud Shell prompt, run the following command to create a new function project folder and switch into it:
```bash
mkdir func-gp-endpoint && cd func-gp-endpoint
```

Run the following command to initialize a new Functions project using the Node.js runtime. This may take a minute while it installs the required packages.
```bash
func init --worker-runtime node --language javascript --model V4
```

Run the following command to add an HTTP-triggered function named GetStatus:
```bash
func new --name GetStatus --template "HTTP trigger" --authlevel anonymous
```

The `--authlevel anonymous` flag means anyone with the URL can call this function without providing a key or signing in. This is useful for testing but should not be used for production endpoints that handle sensitive data.

Confirm the output shows the function was created by running:

```bash
ls src/functions/
```


### Task 3: Deploy the function to Azure

Publish the function project to the Function App you created in the previous exercise.

Run the following command to look up your Function App name and store it in a variable:
```bash
FUNC_APP_NAME=$(az functionapp list --resource-group rg-gp-functions-endpoint --query "[0].name" -o tsv)
echo $FUNC_APP_NAME
```

Run the following command to publish the function project to your Function App:
```bash
func azure functionapp publish $FUNC_APP_NAME
```

Wait for the deployment to complete. The output displays the function's public URL, which looks like:
```bash
Functions in <your-function-app-name>:
    GetStatus - [httpTrigger]
        Invoke url: https://<your-function-app-name>.azurewebsites.net/api/getstatus
```

Copy the Invoke url from the output. You use this URL in the next exercise to test the function.



## Exercise 3: Test endpoint and review logs

### Task 1: Test the HTTP endpoint in a browser

Call your function endpoint to verify it responds correctly. This validates that your serverless function is deployed, running, and reachable from the public internet.

### Task 2: Verify the function in the portal

Confirm the deployed function appears in the Azure portal alongside the Function App you created earlier.

### Task 3: Verify monitoring connection

Before you review logs, confirm that your Function App is connected to Application Insights. In newer Azure portal experiences, monitoring is usually configured during Function App creation and can be verified from the app's monitoring settings.

### Task 4: Restrict access to the function

Now that monitoring is capturing data, change the authorization level so the function requires a key. This demonstrates how to secure a serverless endpoint.

Navigate back to the project folder:
```bash
cd func-gp-endpoint
```

Run the following command to change the authorization level from anonymous to function:

```bash
sed -i "s/authLevel: 'anonymous'/authLevel: 'function'/" src/functions/GetStatus.js
```

Verify the change by running:
```bash
grep authLevel src/functions/GetStatus.js
```

Redeploy the function:
```bash
FUNC_APP_NAME=$(az functionapp list --resource-group rg-gp-functions-endpoint --query "[0].name" -o tsv)
func azure functionapp publish $FUNC_APP_NAME
```


### Task 5: Test restricted access

Verify that the function now rejects all unauthenticated requests, then use a function key to regain access.

### Task 6: Review invocation logs

Use Application Insights to review records of your function invocations. The time spent in the previous tasks gave telemetry time to process.

In the query editor, enter 
```kql
requests | order by timestamp desc
```