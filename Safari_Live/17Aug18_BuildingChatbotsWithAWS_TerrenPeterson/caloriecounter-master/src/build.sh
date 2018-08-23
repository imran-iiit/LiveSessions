#!/bin/bash
# create build package for Lex chatbot, stage in s3 bucket, deploy package, then run a few tests to validate deployment

# create temp zip file with all the json data objects
zip -r foodbot.zip lambda.js data/restaurants.json data/foods.json data/drinks.json data/sauces.json data/dressings.json data/adjustments.json data/chicken.json
zip -r calcbot.zip calculate.js data/foods.json data/drinks.json data/sauces.json data/dressings.json data/adjustments.json
zip -r pizzabot.zip pizza.js data/restaurants.json data/pizzas.json
zip -r miscbot.zip misc.js data/restaurants.json data/foods.json data/drinks.json data/chicken.json data/specials.json data/healthy.json
zip -r chinesebot.zip chinese.js data/foods.json data/drinks.json
zip -r chickenbot.zip chicken.js data/chicken.json data/drinks.json

# copy the build file and source files to a staging bucket in case need for research
aws s3 cp lambda.js s3://fastfoodchatbot/binaries/
aws s3 cp pizza.js s3://fastfoodchatbot/binaries/
aws s3 cp calculate.js s3://fastfoodchatbot/binaries/
aws s3 cp misc.js s3://fastfoodchatbot/binaries/
aws s3 cp chinese.js s3://fastfoodchatbot/binaries/
aws s3 cp chicken.js s3://fastfoodchatbot/binaries/
aws s3 cp foodbot.zip s3://fastfoodchatbot/binaries/
aws s3 cp pizzabot.zip s3://fastfoodchatbot/binaries/
aws s3 cp calcbot.zip s3://fastfoodchatbot/binaries/
aws s3 cp miscbot.zip s3://fastfoodchatbot/binaries/
aws s3 cp chinesebot.zip s3://fastfoodchatbot/binaries/
aws s3 cp chickenbot.zip s3://fastfoodchatbot/binaries/
echo 'copied zip files and source code to s3'

aws s3 cp data/foods.json s3://fastfoodchatbot/data/
aws s3 cp data/drinks.json s3://fastfoodchatbot/data/
aws s3 cp data/pizzas.json s3://fastfoodchatbot/data/
aws s3 cp data/restaurants.json s3://fastfoodchatbot/data/
aws s3 cp data/sauces.json s3://fastfoodchatbot/data/
aws s3 cp data/dressings.json s3://fastfoodchatbot/data/
aws s3 cp data/adjustments.json s3://fastfoodchatbot/data/
aws s3 cp data/chicken.json s3://fastfoodchatbot/data/
aws s3 cp data/specials.json s3://fastfoodchatbot/data/
aws s3 cp data/healthy.json s3://fastfoodchatbot/data/
echo 'copied data files to s3'

# cleanup temporary zip files
rm foodbot.zip
rm pizzabot.zip
rm calcbot.zip
rm miscbot.zip
rm chinesebot.zip
rm chickenbot.zip
echo 'removed temp files'

# update the lambda function with the binaries that have been staged
aws lambda update-function-code --function-name myCalorieCounterGreen --s3-bucket fastfoodchatbot --s3-key binaries/foodbot.zip
aws lambda update-function-code --function-name myPizzaCalorieCounterGreen --s3-bucket fastfoodchatbot --s3-key binaries/pizzabot.zip
aws lambda update-function-code --function-name myCalorieCalculatorGreen --s3-bucket fastfoodchatbot --s3-key binaries/calcbot.zip
aws lambda update-function-code --function-name myCalorieBotMiscMsgGreen --s3-bucket fastfoodchatbot --s3-key binaries/miscbot.zip
aws lambda update-function-code --function-name myChineseFoodCalculatorGreen --s3-bucket fastfoodchatbot --s3-key binaries/chinesebot.zip
aws lambda update-function-code --function-name myChickenCounterGreen --s3-bucket fastfoodchatbot --s3-key binaries/chickenbot.zip
echo 'new versions of lambda functions has been deployed'

# read in test data required for a food validation request
echo 'test case 1 - food validation'
cd testing
request=$(<request.json)
cd ..

# invoke the new lambda function
aws lambda invoke --function-name myCalorieCounterGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 1 complete'

# read in test data required for a food calculation request
echo 'test case 2 - food calculation'
cd testing
request=$(<calcRequest.json)
cd ..

# invoke the new lambda function
aws lambda invoke --function-name myCalorieCalculatorGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 2 complete'

# read in test data required for the pizza test
echo 'test case 3 - pizza request'
cd testing
request=$(<pizzaRequest.json)
cd ..

# invoke the new lambda function
aws lambda invoke --function-name myPizzaCalorieCounterGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 3 complete'

# read in test data required for the pizza test
echo 'test case 4 - misc request'
cd testing
request=$(<miscRequest.json)
cd ..

# invoke the new lambda function
aws lambda invoke --function-name myCalorieBotMiscMsgGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 4 complete'

# read in test data required for the pizza test
echo 'test case 5 salad request'
cd testing
request=$(<saladRequest.json)
cd ..

# invoke the lambda function for validating food
aws lambda invoke --function-name myCalorieCounterGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 5 complete'

# read in test data required for the pizza test
echo 'test case 6 chinese food request'
cd testing
request=$(<chineseRequest.json)
cd ..

# invoke the lambda function for validating food
aws lambda invoke --function-name myChineseFoodCalculatorGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 6 complete'

# read in test data required for the pizza test
echo 'test case 7 sub of day request'
cd testing
request=$(<subDayRequest.json)
cd ..

# invoke the lambda function that checks on the sub of the day
aws lambda invoke --function-name myCalorieBotMiscMsgGreen --payload "$request" testOutput.json > temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 7 complete'

# clean-up any temporary data
#aws s3 rm foodbot.zip s3://fastfoodchatbot/binaries/
rm testOutput.json

# wrap-up
echo 'completed new deployment'
