namespace :s3 do
  desc "Creates a new S3 bucket and outputs or uploads the credentials."
  task :create_bucket do
    puts "Please enter the name for your new bucket"
    name = $stdin.gets.strip
    region = "eu-central-1"
    sh "aws s3 mb s3://#{name} --region #{region}"
    sh "aws iam create-user --user-name #{name}"
    policy = <<~JSON
      {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:CreateBucket",
                    "s3:DeleteObject",
                    "s3:Put*",
                    "s3:Get*",
                    "s3:List*"
                ],
                "Resource": [
                    "arn:aws:s3:::#{name}",
                    "arn:aws:s3:::#{name}/*"
                ]
            }
        ]
      }
    JSON
    File.write("policy.json", policy)
    sh "aws iam put-user-policy --user-name #{name} --policy-name #{name} --policy-document file://policy.json"
    File.delete("policy.json")
    content = JSON.parse `aws iam create-access-key --user-name #{name}`
    id = content.dig("AccessKey", "AccessKeyId")
    secret = content.dig("AccessKey", "SecretAccessKey")
    puts "Credentials and bucket were generated. Automatically assign them to the associated Heroku project? This will override and delete all current keys on Heroku. (y/n)"
    vars = {AWS_REGION: region, AWS_BUCKET: name, AWS_ACCESS_KEY_ID: id, AWS_SECRET_ACCESS_KEY: secret}
    if $stdin.gets.strip == "y"
      sh "heroku config:set #{vars.map { |k, v| "#{k}=#{v}" }.join(" ")}"
    else
      vars.each { |k, v| puts "#{k}=#{v}" }
    end
  end
end
