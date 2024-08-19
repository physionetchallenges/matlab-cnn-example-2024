# MATLAB example code for the George B. Moody PhysioNet Challenge 2024

Click here to open this example in MATLAB Online:

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=physionetchallenges/matlab-cnn-example-2024)

## What's in this repository?

This repository contains a simple example that illustrates how to format a MATLAB entry for the [George B. Moody PhysioNet Challenge 2024](https://physionetchallenges.org/2024/). Like the [simple example](https://github.com/physionetchallenges/matlab-example-2024) that is provided, you can remove some of the code, reuse other code, and add new code to create your entry. You do not need to use the models, features, and/or libraries in this example for your entry. We encourage a diversity of approaches for the Challenges.

For this example, we implemented a basic convolutional neural network to demonstrate classification on an image dataset. You can try it by running the following commands on the Challenge training set. If you are using a relatively recent personal computer, then you should be able to run these commands from start to finish on a very small subset (100 records) of the training data in less than 30 minutes.

We also provide a basic introduction to Image Processing in MATLAB, which can be viewed by opening 'GetStartedWithImageProcessing.mlx'

## How do I run these scripts?

First, you can download and create data for these scripts by following the instructions in the "How do I create data for these scripts?" section in the [Python example code repository](https://github.com/physionetchallenges/python-example-2024).

Second, you can choose to install the [WFDB Toolbox for MATLAB and Octave](https://physionet.org/physiotools/wag/wag.htm) by following the instructions on [this page](https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/).

You can train your model(s) by running

    train_model(input_directory, output_directory, verbose)

where

- `input_directory` (input; required) is a folder with the training data files, including the images and diagnoses (you can use the `ptb-xl/records100/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024)); and
- `output_directory` (output; required) is a folder for saving your model(s); and
- `verbose` (parameter; optional) is a binary flag to either show (1) or suppress (0) optional text output.

You can run your trained model(s) by running

    run_model(input_directory, model_directory, output_directory, allow_failures, verbose)

where

- `input_directory` (input; required) is a folder with the validation or test data files (you can use the `ptb-xl/records100_hidden/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024), but it would be better to repeat these steps on a new subset of the data that you did not use to train your model);
- `model_directory` (input; required) is a folder for loading your model(s); and
- `output_directory` (output; required) is a folder for saving your model outputs; and
- `allow_failures` (parameter, optional) is a binary flag to allow for individual failures (1) or to end the program upon encountering an error during prediction (0); and
- `verbose` (parameter; optional) is a binary flag to either show (1) or suppress (0) optional text output.

The [Challenge website](https://physionetchallenges.org/2024/#data) provides a training database with a description of the contents and structure of the data files.

You can evaluate your model by pulling or downloading the [evaluation code](https://github.com/physionetchallenges/evaluation-2024) and running

    evaluate_model(labels, test_outputs, scores.csv)

where

- `labels` is a folder with labels for the data, such as the training database on the PhysioNet webpage (you can use the `ptb-xl/records100/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024), but it would be better to repeat these steps on a new subset of the data that you did not use to train your model);
- `test_outputs` is a folder containing files with your model's outputs for the data; and
- `scores.csv` (optional) is file with a collection of scores for your model.

## How do I create data for these scripts?

You can use the scripts in [this repository](https://github.com/physionetchallenges/python-example-2024) to generate synthetic ECG images for the [PTB-XL dataset](https://www.nature.com/articles/s41597-020-0495-6). You will need to generate or otherwise obtain ECG images before running the above steps.

## Which scripts I can edit?

Please edit the following script to add your code:

* `train_models.m` is a script for training your models.
* `load_models.m` is a script for loading your trained models.
* `run_models.m` is a script for running your trained models.

Please do **not** edit the following scripts. We will use the unedited versions of these scripts when running your code:

* `train_model.m` is a script for training your model(s).
* `run_model.m` is a script for running your trained model(s).

These scripts must remain in the root path of your repository, but you can put other scripts and other files elsewhere in your repository.

## How do I train, save, load, and run my model?

You can choose to create digitization and/or classification models.

To train and save your model(s), please edit the `train_models.m` script. Please do not edit the input or output arguments of this function.

To load and run your trained model(s), please edit the `load_models.m` and `run_models.m` scripts. Please do not edit the input or output arguments of these functions.

## What else do I need?

This repository does not include data or the code for generating ECG images. Please see the above instructions for how to download and prepare the data.

This repository does not include code for evaluating your entry. Please see the [evaluation code repository](https://github.com/physionetchallenges/evaluation-2024) for code and instructions for evaluating your entry using the Challenge scoring metric.

## How do I learn more? How do I share more?

Please see the [Challenge website](https://physionetchallenges.org/2024/) for more details. Please post questions and concerns on the [Challenge discussion forum](https://groups.google.com/forum/#!forum/physionet-challenges). Please do not make pull requests, which may share information about your approach.

## Useful links

* [Request a MATLAB license](https://www.mathworks.com/academia/student-competitions/physionet.html)
* [Challenge website](https://physionetchallenges.org/2024/)
* [Python example code](https://github.com/physionetchallenges/python-example-2024)
* [Evaluation code](https://github.com/physionetchallenges/evaluation-2024)
* [Frequently asked questions (FAQ) for this year's Challenge](https://physionetchallenges.org/2024/faq/)
* [Frequently asked questions (FAQ) about the Challenges in general](https://physionetchallenges.org/faq/)
