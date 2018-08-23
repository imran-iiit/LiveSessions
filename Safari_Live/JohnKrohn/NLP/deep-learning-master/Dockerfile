FROM jupyter/tensorflow-notebook:c64b1e33ae52

# launchbot-specific labels
LABEL name.launchbot.io="Deep Learning"
LABEL workdir.launchbot.io="/home/jovyan"
LABEL description.launchbot.io="Deep Learning"
LABEL 8888.port.launchbot.io="Start Tutorial"

#Set the working directory
WORKDIR /home/jovyan/

# Modules
COPY requirements.txt /home/jovyan/requirements.txt
RUN pip install -r /home/jovyan/requirements.txt

# NLTK downloads
RUN python -m nltk.downloader punkt
RUN python -m nltk.downloader stopwords
RUN python -m nltk.downloader gutenberg

# Add files
COPY notebooks /home/jovyan/notebooks
COPY data /home/jovyan/data
COPY solutions /home/jovyan/solutions

# Allow user to write to directory
USER root
RUN chown -R $NB_USER /home/jovyan \
    && chmod -R 774 /home/jovyan
USER $NB_USER

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=* --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --NotebookApp.iopub_data_rate_limit=1.0e10
