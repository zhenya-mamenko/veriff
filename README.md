# Veriff Full stack test task

## Frontend

Exec command ```npm run build```
then ```docker build -t veriff-test```
and then ```docker run --restart always -d -p 80:3000 veriff-test```

You can change backend path in ```consts.js```.

## Backend

Backend config: IIS 7.5, ASP.Net, C#, .Net 4.8.

You need to set variables API_KEY and API_SECRET and connection string named "veriff". 
