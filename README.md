# Active Learning with CNNs

Experiments with Active Learning for Convolutional Neural Networks for my master's thesis in Computer Science. Work in progress.

The repository for the document is https://github.com/mariobecerra/msc_thesis. Also work in progress.

## Folders:

- `code`: All code used for the experiments. Files:

  - `utils.py`: Python functions that are used from the R scripts. Here are the acquisition funtions and the dropout predictions from the models.

  - `MNIST_active_learning.R`: Performs the active learning acquisition steps for the MNIST dataset.
  
  - `MNIST_utils.R`: Functions used in `MNIST_active_learning.R` to perform the active learninng steps.
  
  - `MNIST_utils.py`: Python functions used in `MNIST_active_learning.R` to perform the active learninng steps. Particularly, the Keras model.
  
  - `MNIST_plot_probs.R`: Creates probability plot used in Results chapter.
  
  - `MNIST_plot_accuracies.R`: Creates accuracy plot used in Results chapter.
  
  - `MNIST_model_dropout.py`: Unused. To be deleted.

- `data`: Training and test data. Subfolders:
  
  - `cats_dogs`: 
    
    - `test1`: Test data.
    
    - `train`: Training data.
  
  - `cifar-10-batches-py`: Unused. To be deleted.
  
  - `cifar-100-python`: Unused. To be deleted.
  
  - `earthquake`: Unused. To be deleted.

- `out`: Objects and files created go here.



