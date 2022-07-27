<img src="https://github.com/EqualityAI/Checklist/blob/master/img/color logo only.PNG" align="left" alt="EqualityAI Logo" width="65" />

# Equality AI `responsible_mlops`
[Equality AI (EAI)](https://equalityai.com/) is the first organization to begin assembling the [Responsible AI framework]() into an end-to-end Responsible MLOPs Studio. The technology behind our Responsible MLOPs Studio is an open source ML software framework and tool, called `responsible_mlops`, with additional functions that can be selectively incorporated to create various workflows designed to produced <b>equitable, responsible models.</b>

<b>[Read our EAI Manifesto]([https://equalityai.com#manifesto](https://github.com/EqualityAI/responsible_mlops/blob/main/MANIFESTO.md)) and star this repo to show your support!!!</b>

## What is Responsible AI?
In 2019, [Obermeyer et al.]() revealed a Healthcare commercial prediction algorithm affecting the care of millions of patients <font size="5"><i>exhibiting significant racial bias</i></font> that had gone <b><font size="5">undetected</font></b>, resulting in <b><font size="5">Black patients</font></b> with complex medical needs not qualifying for extra care, despite being considerably sicker than White patients. Recent scrutiny of machine learning (ML) usage in healthcare systems has revealed numerous examples of harmful medical decisions made at the <b><font size="5">expense of minority and vulnerable populations.</font></b> Medical professionals and researchers relying on ML models to assist in decision making are often unaware of the bias unintentionally introduced into algorithms by real-world data that incorporates inherent unfairness and produces biased outcomes that widen the gap in healthcare inequity.   

<details>
  <summary><font size="2"><i>More studies ...</i></font></summary>
  <hr/>
  </details>

Data scientists are the newest members of the healthcare team, and as such, the Hippocratic Oath applies:  First do no harm.  Developers must accept greater responsibility to ensure the ML models they develop do no harm.  Unfortunately, the typical tools and MLOps workflows available to developers have proven to be insufficient for this task. Responsible AI is an emerging framework that addresses this need and helps mitigate the potential risks of harm from AI and includes ethics, fairness, accuracy, security, and privacy.  

<details>
  <summary><font size="2"><i>See full framework ...</i></font></summary>
  <img src="img/framework.png" align="center" alt="" width="900" />
  </details>

## `responsible_mlops` 
To make steps in our `responsible_mlops` easy to follow, our expert statisticians, academic partners and machine learning experts have likened these various workflows to something everyone can understand—a recipe. These recipes outline the “ingredients” you need and the exact steps to take to ensure you’ve cooked up a fair machine learning model. Our first recipe is a [fair preprocessing ML recipe]() and the main goal of this recipe is to repair the data set on which the model is run (pre-processing).</br>

<details>
  <summary><font size="2"><i>Learn more ...</i></font></summary>
  To create a fair preprocessing ML algorithm, you will need to incorporate two crucial functions into your ML workflow:  a mitigation method and a fairness metric.  Mitigation methods are employed to address bias in data and/or machine learning models and achieve fairness in output.  Fairness metrics are needed to mathematically represent the fairness or bias levels of a machine learning model. <br></br>

Let’s assemble the "ingredients" and get started!

**Ingredients**
* Your research question (or run our use case)
* Source data (or use our sample data)
* Fairness metric
* Mitigation method
* Integrated development environment (IDE), such as R studio
* R programming language, Python version coming soon
* Access to the Equality AI GitHub repository
</hr>
  </details>

[Sign up]() to hear when we release recipes that will tackle adjustments to the model (in processing) and the predictions (post-processing).

## Highlighted functions
With the release of our Fair Preprocessing Machine Learning Recipe, we want to introduce our `fairness_tree_metric` and `mitigation_method_mapping` functions that provide guidance on choosing appropriate fairness metrics and determining suitable fairness mitigation strategies.

<b>Data Fetch:</b> connect to source data (or use our sample data)</br>

<b>Select Fairness and Mitigation Strategy:</b> `fairness_tree_metric` and `mitigation_method_mapping` functions that provide guidance on choosing appropriate fairness metrics and determining suitable fairness mitigation strategies </br>

<details>
  <summary><font size="4"> fairness_tree_metric() </font></summary></br>
  <b>Arguments:</b> fairness_tree_info <br></br>

Takes in the parameter fairness_tree_info. Fairness_tree_info includes EAI's fairness_tree.csv that has coverted this [recently published decision tree](https://arxiv.org/abs/2006.16745) into a table. When the `fairness_metric_tree()` is executed it will print a series of questions to the R console. For each question the user will be prompted to answer <i><b>(Y, y, Yes, or yes)</b></i> or No <i><b>(N, n, No, or no)</b></i>. As the user answers each question they will move through the decision tree until reaching the appropriate fairness metric to use.
  
  ```
  fairness_tree_info <- read.csv(file.path(getwd(),"config","fairness_tree.csv"), sep=',') 
  
  fairness_metric_tree <- fairness_tree_metric(fairness_tree_info)
  ```

<details>
  <summary><font size="2"><i> See example </i></font></summary></br>
  
  ```
> # Fairness metric selection
> fairness_tree_info <- read.csv(file.path(getwd(),"config","fairness_tree.csv"), sep=',')#, fileEncoding="UTF-8-BOM")
> fairness_metric_tree <- fairness_tree_metric(fairness_tree_info) 

[1] "QUESTION: Does your algorithm use an individual's sensitive variable information (intentional discrimination) to make a decision?"
[1] "EXAMPLE: For example, do you use a person's gender to make the decision?"
[1] "ANSWER: Yes/No"
 N

[1] "QUESTION: Do you want to assess if your population is disadvantaged by multiple sources of discrimination such as race, class, gender, religion, and other inner traits?"
[1] "EXAMPLE: For example, multiple sources would include accounting for all of a patient's attributes such as their gender, their age, etc... when measuring fairness"
[1] "ANSWER: Yes/No"
 N

[1] "QUESTION: Are there any standards or regulations enforced to avoid discrimination with regard to the decision being made?"
[1] "EXAMPLE: An example standard would be an internal organizational policy imposing diversity among employees such as hiring equally from sensitive variable groups."
[1] "ANSWER: Yes/No"
 N

[1] "QUESTION: Is there a reliable label or ground truth for the outcome of interest? Is there no historical or measurement bias?"
[1] "EXAMPLE: An example of areas where ground truths are available are disease prediction or hospital readmission. There is no ground truth when predicting whether a job  applicant is hired or college admission since the outcome in the training data is inferred by a human decision maker (subjective). Historical bias occurs when the data legitimately collected over time leads to unwanted outcomes and measurement biases occurs when features or labels are not measured accurately. "
[1] "ANSWER: Yes/No"
 N

[1] "QUESTION: Do you have features/explanatory variables in your data that provide information about the outcome variable while at the same time are correlated with the sensitive variable?              "
[1] "EXAMPLE: For example, a person's height may be an effective predictor for whether they can receive a kidney from a donor but also can be highly correlated with gender."
[1] "ANSWER: Yes/No"
 N
 
[1] "Fairness Metric: Statistical Parity"

  ```
  </details>
    </details> </br>

<b>Data preparation</b></br>

<details>
  <summary><font size="4"> data_prepare_nhamcs() </font></summary></br>
  <b>Arguments:</b> .data, target_variable, method_options <br></br>

Takes in the parameter method options. The options available include method_missing=<i><b>'mi_impute'</b></i>, which allows for multiple imputation of missing values and max_iter = <i><b>is the number of iteration for each imputation.</b></i>.
  
  ```
  method_options<-list(method_prepare='Zhang', method_missing='mi_impute', max_iter=5) 
  
  data_clean <- data_prepare_nhamcs(data_raw$data, data_raw$target_variable, method_options) 
  ```
</details>


<details>
  <summary><font size="4"> train_test_split() </font></summary></br>
  <b>Arguments:</b> .data, target_variable, train_size <br></br>

Takes in the above parameters to split your train and test set data. The options available include train_size=<i><b>0-1</b></i>, and the default is set to 0.7 (i.e., 70% training data and 30% testing split).
  
  ```
  data_clean <- train_test_split(data_clean$data, target_var, train_size = train_data_size) 
  ```
</details>


<details>
  <summary><font size="4"> data_balancing() </font></summary></br>
  <b>Arguments:</b> .data, target_var, and method_balancing <br></br>

Takes in the above parameters to makes sure that the class frequencies of the target variable is balanced in the dataset. Two methods of data balancing are implemented: <i><b>down-sampling and up-sampling</i></b> (both are from the `caret` package). Down-sampling randomly subset all the classes in the training set so that their class frequencies match the least prevalent class. For example, suppose that 80% of the training set samples are the first class and the remaining 20% are in the second class. Down-sampling would randomly sample the first class to be the same size as the second class (so that only 40% of the total training set is used to fit the model). Up-sampling randomly sample the minority class to be the same size as the majority class.
  
  ```
  data_clean$training <- data_balancing(data_clean$training, target_var, method_balancing) 
  ```
</details>


 


























<details>
  <summary><font size="4"> mitigation_method() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>

  <details>
  <summary><font size="4"> data_prepare_nhamcs() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>

  <details>
  <summary><font size="4"> train_test_split() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>
  
   <details>
  <summary><font size="4"> data_balancing() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>

   <details>
  <summary><font size="4"> ml_model() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>
  
   <details>
  <summary><font size="4"> ml_results() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>
  
  
   <details>
  <summary><font size="4"> ml_model() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>
  
     <details>
  <summary><font size="4"> fairness_metric() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>
  
       <details>
  <summary><font size="4"> bias_mitigation() </font></summary>
  <b>Arguments</b>
  &emsp; .data </br>
  &emsp;&emsp; A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr). See Methods, below, for more details.
  </details>


## Responsible AI Takes a Community
We are starting with fairness, and it doesn’t end there. We have much more in the works,  and we want to know—what do you need? Do you have a Responsible AI challenge you need to solve? Drop us a line and let’s see how we can help! 

## Contributing to the project
Equality AI uses both GitHib and Slack to manage our open source community. To participate:

1. Join the Slack community (https://equalityai.com/slack)
    + Introduce yourself in the #Introductions channel. We're all friendly people!
2. Check out the [CONTRIBUTING](https://github.com/EqualityAI/responsible_mlops/blob/main/CONTRIBUTING.md) file to learn how to contribute to our project, report bugs, or make feature requests.
3. Try out the [Responsible MLOPs Toolkit](https://github.com/EqualityAI/responsible_mlops)
    + Hit the top right "star" button on GitHub to show your love!
    + Follow the recipe above to use the code. 
4. Provide feedback on your experience using the [GitHub discussions](https://github.com/EqualityAI/respomsible_mlops/discussions) or the [Slack #support](https://equalityai.slack.com/archives/C03HF7G4N0Y) channel
    + For any questions or problems, send a message on Slack, or send an email to contact@equalityai.com.


## Authors
<img src="https://github.com/EqualityAI/Checklist/blob/master/img/color logo only.PNG" align="left" alt="" width="75" />

[Equality AI](https://equality-ai.com/) is a public benefit corporation dedicated to helping data scientists close the health disparity gap by assembling a Responsible AI framework into tools that include modernized, end-to-end MLOps with functions that can be selectively incorporated to create various workflows designed to produced equitable, responsible models. <br></br>  
