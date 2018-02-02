---
layout: post
comments: true
title:  "Passing The AWS Professional Solutions Architect Exam"
date:   2018-02-01 06:27:00 +0454
categories: AWS Professional Architecture Cloud Exam DevOps Abdennour Tunisia
---

# Introduction

After passing all the AWS Associate certification exams and daily working with AWS technologies for over two years, I hesitated between the two Professional level exams;  **AWS DevOps engineer certification exam** or **AWS Professional Solutions Architect certification exam**.

Finally, I passed both:  AWS DevOps engineer certification exam was achieved the last month and AWS Professional Solutions Architect was successfully completed yesterday.

In this post, I will share my experience with the last one in case anybody is planning for it.


## Motivations

- Daily work with AWS technologies within DevOps environment/processes for almost 2 years.

- Loving technologies: especially software architecture and in general **architecture**.

- The future is the Cloud : I believe that almost all applications will be migrated to the Could, now or later. If not, an hybrid environment would be instead.

- Architecting Solutions by making the marriage among **High Availability**, **scalability**, **reliability**, **durability**, **performance**, **fault tolerance**, **security** and **cost efficiency**.

- High Availability & Business Continuity : High Availability is not only keeping servers online, it is *keeping the Business "online"*.

- "if you pass this I believe you deserve the credentials." ⁽¹⁾


## Challenges

- No prior experience with Professional exams in **architecture** (.ie. TOGAF ):  The AWS Professional Solutions architect exam is the first professional exam about architecture, and I am really glad to pass it since the first attempt.

- Tremendous range of topics and services: CloudFormation, CloudFront, CloudWatch, SNS, EC2, EBS, ELB, ALB, EMR, Data Pipeline, VPC, VPN, Direct Connect, ElastiCache, Elastic Beanstalk, OpsWorks, Elastic Transcoder, AWS Key Management Service, AWS Security Token Service, , CloudHSM, CloudSearch, IAM, Kinesis, RDS, DynamoDB, RedShift, S3, Glacier, Storage Gateway, AWS Import/Export, Route 53, SQS, SWF, SES, ,...almost everything


- AWS is frequently updating existing services and is continuously releasing new services: Definitely, they don't assume to know all services, Nevertheless, you feel there is no line of measurement.

## Preparation

- **Re:Invent:** Watch as many of the [Re:Invent videos](http://reinventvideos.com), specifically the deep dive ones; they actually contain information directly applicable to the exam.

- Experimenting with the services themselves: Labs, hands-on

- Online Course: I watched CSA Professional exam Preparation courses of Linuxacademy.com, cloudacademy.com and acloud.guru. They were all wonderful and they are a set of complementary courses.

- **White papers** : Do not ignore this treasure.

## Tips

# General tips

- Forget thinking about answers as right ("true") or wrong ("false"). In this exam, you may choose between the better and the best. Or, you may prioritize  the "worse" upon the worst. ⁽²⁾ “ليس العاقل الذي يعلم الخير من الشر، و إنما العاقل الذي يعلم خير الخيرين و شر الشرين.” :  which means "The wise is not who differentiates between right and wrong. but the wise differentiates between the best and the better, and differentiates between the worst and the worse".

- Have a good understanding of all objectives explained in the [blueprint](https://d1.awsstatic.com/training-and-certification/docs-sa-pro/AWS_certified_solutions_architect_professional_blueprint.pdf) and how they interact with each other.


# Exam tips


- EBS optimization, IOPS, Burstable credits.

- Federated access, AssumeRoleWithSAML & AssumeRoleWithWebIdentity know the difference among them.

- Mobile push notification using SNS.

- ElasticBeanstalk vs OpsWorks : Smattering is not enough, a deep knowledge and hands-on are crucial.

- DDoS attacks mitigation.

- IDS/IPS setup ... promiscuous  mode is not allowed in AWS VPC. Keep this in mind!


- Hybrid solutions: VPN IPsec vs Direct Connect : The first is suitable for security and integrity requirements and the last is suitable for network consistency (High and stable bandwidth throughput).

- Direct connect again: If you feel you cannot understand this technology, deep dive into it by watching courses about AWS advanced networking exam preparation.

- Implement DR or Disaster recovery : There are 4 models. Deep dive into them.

- RTO vs RPO in the context of DR.

- Reach low RTO by: elastic scaling,  monitoring scripts.

- Reach low RPO by: consistent backup tools.

- Why multi-AZ architecture , Why multi-region architecture ?


____


**References**

⁽¹⁾: [http://ozaws.com/2015/09/17/aws-professional-solution-architect-certification-tips/](http://ozaws.com/2015/09/17/aws-professional-solution-architect-certification-tips/)

⁽²⁾: Stated by Taqī ad-Dīn Ahmad ibn Taymiyyah before 700 years
