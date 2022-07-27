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

<details>
  <summary><font size="4"> fairness_tree_metric() </font></summary>
  <b>Arguments</b>

fairness_tree_info 

Takes in the parameter fairness_tree_info. Fairness_tree_info includes EAI's fairness_tree.csv that has coverted this [recently published decision tree]() into a table. When the `fairness_metric_tree()` is executed it will print a series of questions to the R console. For each question the user will be prompted to answer Yes <i>(Y, y, Yes, or yes)</i> or No <i>(N, n, No, or no)</i>. As the user answers each question they will move through the decision tree until reaching the appropriate fairness metric to use.
  
  ```
  fairness_tree_info <- read.csv(file.path(getwd(),"config","fairness_tree.csv"), sep=',') 
  
  fairness_metric_tree <- fairness_tree_metric(fairness_tree_info)
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
