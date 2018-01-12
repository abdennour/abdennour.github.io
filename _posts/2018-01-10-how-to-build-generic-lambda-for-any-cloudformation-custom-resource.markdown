---
layout: post
title:  "How to build Generic Lambda for any Cloudformation custom resource"
date:   2018-01-10 06:03:00 +0733
categories: Cloudformation Lambda infrastructure-as-code DevOps javascript nodejs AWS Cloud
---

# Prerequisites:

This post requires at least :

- A basic knowledge of AWS Cloudformation (CFN is an abbreviation).
- A basic knowledge of YAML (or JSON ).
- The philosophy of "infrastructure as a code" is a plus.




# Introduction:

  With the coming of "Custom Resources", building Cloudformation templates becomes amazing. Indeed, the yaml/json template becomes alive, dynamic and reusable.


  Custom resources are awesome, but :

  - How to avoid worst practices ?
  - How to avoid creating lambda function for each customized logic ?

  When dealing with **Cloudformation custom resources**, you may think about creating a lambda function for each custom resource (for each custom logic).

  Thus, is it possible to have a shared Lambda among all custom resources?

  So, let's see together the implementation of this shared function.

  Before that, we will show the need for this shared function by explaining more the problem.

# Problem :

Assuming that we want to reuse a CFN parameter  (i.e: Environment) many times but with different cases ( Lowercase, CamelCase).

```yaml
Parameters:
  Environment:
    Type: String
    AllowedValues:
      - PROD
      - DEV
      - STAGING
```  

Intuitively, we will build a Lambda function for each case conversion :

**LowerCaseFunction**

```yaml
# If you want to test this , to not forget to define "LambdaExecutionBasicRole" resource
CustomLowerCaseEnvironment:
  Type: Custom::GetLowerCaseEnvironment
  Properties:      
    ServiceToken: !GetAtt toLowerCaseFunction.Arn
    value: !Ref Environment

toLowerCaseFunction:
  Type: AWS::Lambda::Function
  Properties:
    Handler: "index.handler"
    Runtime: "nodejs6.10"
    Timeout: 120
    Role: !GetAtt LambdaExecutionBasicRole.Arn
    Code:
      ZipFile: |
       const response= require('cfn-response');
       exports.handler = function(event, context) {
         const { value } = event.ResourceProperties; // ⚠️ Get Properties
         if (event.RequestType === 'Create') {
           response.send(event, context, response.SUCCESS, {
             value: value.toLowerCase() // ⚠️  Here the main instruction
           });
           return;
         }

         if (event.RequestType === 'Delete') return response.send(event, context, response.SUCCESS);
       };
Outputs:
  LowerCaseEnvironment:
    Value: !Ref CustomLowerCaseEnvironment.value
```

Now, you got a lowercase of the "Environment" parameter. However, is it worth to write all this code to only convert the case of a string parameter?

What will happen if we want more customized logic, not only case conversion, not only string manipulation?


# Solution


The NodeJS module [vm](https://nodejs.org/api/vm.html) is a great library for running javascript code from strings and inejecting in-scope variables.

The following snippet was brought from the official documentation as an overview about "vm" usage:

```js
const vm = require('vm');

const x = 1;

const sandbox = { x: 2 };
vm.createContext(sandbox); // Contextify the sandbox.

const code = 'x += 40; var y = 17;';
// x and y are global variables in the sandboxed environment.
// Initially, x has the value 2 because that is the value of sandbox.x.
vm.runInContext(code, sandbox);

console.log(sandbox.x); // 42
console.log(sandbox.y); // 17

```

Really, "vm" can be the best solution here for the implementation of the shared lambda.

**Custom Resource Design**

In order to integrate with the shared lambda, the custom resource must provide the following properties :

- *code (Required)*
- *Other properties* : The more you define properties, the more you can use them directly inside the "code" property. Indeed, the NodeJs module "vm" will inject them into the scope and prevent from getting  "undefined variable" errors.


The shared lambda function reads those properties from `event.ResourceProperties`.
Then, the lambda function leverage "vm" by mapping custom resource properties to its arguments:

- *code* arg    : is the "code" property of the custom resource.
- *sandbox* arg : is the literal object  containing all other properties of the custom resource.

The following custom resource has two properties:

- code (required)
- environment

Definitely,"environment" is used directly in the "code" without any declaration.

```yaml
LowerCaseCustomerResource:
  Type: Custom::GetLowerCase
  Properties:
    ServiceToken: !GetAtt SharedLambda.Arn
    environment: !Ref Environment
    code: |
       environment = environment.toLowerCase();

```

Another example can make it more clear and prove how it is useful; We will not only manipulate strings but also we can deep dive into other logic . Let's perform a sum operation between two numbers leveraging this shared function.

Thus, the custom resource must define "arg1" and "arg2" properties along side with  "code" property.


```yaml

SumCustomResource:
 Type: Custom::GetSum
 Properties:
   ServiceToken: !GetAtt SharedLambda.Arn
   arg1: 3
   arg2: 45
   code: |
      var result = arg1 + arg2;  
```

Hence, the value of `!GetAtt SumCustomResource.result` is `3+45` which is `48`.

So How does the shared function look like ?

```yaml
SharedLambda:
  Type: AWS::Lambda::Function
  Properties:
    Role: !GetAtt LambdaExecutionBasicRole.Arn
    Handler: "index.handler"
    Runtime:  "nodejs6.10"
    Timeout: 120
    Code:
      ZipFile: |
        const response = require('cfn-response');
        const vm = require('vm');

        exports.handler = (event, context, callback) => {

            if (event.RequestType === 'Create' || event.RequestType === 'Update') {
                // Extract params from event
                const { code } = event.ResourceProperties;
                const sandbox = Object.assign({} , event.ResourceProperties);
                delete sandbox.code;
                // execution
                vm.createContext(sandbox); // Contextify the sandbox.
                vm.runInContext(code, sandbox);
                response.send(event, context, response.SUCCESS, sandbox);
            }
        };

```


Another usage can be also :

```yaml
 Ec2Image:
  Type: Custom::GetEC2Image
  Properties:
    ServiceToken: !Ref LambdaRole.Arn
    region: !Ref AWS::Region
    platform: Linux
    code: |
      const shell = require('process_child').execSync;
      const cmd = `aws ec2 describe-images --owners amazon --filters "Name=platform,Values=${platform}" "Name=root-device-type,Values=ebs"` --region ${}
      var images = JSON.parse(shell(cmd));
      //...so on and so forth




```

Even though the shared Lambda will require more privileges (ec2:DescribeImages), it is worth to have one and only one lambda to handle inputs/outputs of any Cloudformation custom resource.

Nevertheless, we can leverage nested stacks and let the shared lambda more reusable by avoid hard coding its IAM role.

Enjoy! 👍🏻
