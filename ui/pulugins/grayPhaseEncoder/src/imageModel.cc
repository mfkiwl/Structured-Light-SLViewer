#include "grayPhaseEncoder/include/imageModel.h"
#include <QFileInfo>
#include <QDir>

ImageModel::ImageModel(QObject *parent) : QAbstractListModel(parent) {
  m_roleNames.insert(FileName, "FileName");
}

ImageModel::~ImageModel() {}

int ImageModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent);
  return m_imgs.count();
}

QVariant ImageModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid()) return QVariant();

  switch (role) {
    case FileName: {
      return m_imgs.value(index.row());
    }
    default:
      break;
  }

  return QVariant();
}

void ImageModel::emplace_back(const QString &imgInfo) {
  beginResetModel();

  m_imgs.push_back(imgInfo);

  endResetModel();
}

int ImageModel::erase(const QString &imgInfo) {
  beginResetModel();

  int index = 0;
  auto iterator = m_imgs.begin();
  for (; iterator != m_imgs.end(); ++iterator) {
    if (imgInfo == *iterator) {
      m_imgs.erase(iterator);
      break;
    }
    ++index;
  }

  endResetModel();

  if (iterator == m_imgs.end()) return -1;

  return index;
}

void ImageModel::erase(const int locIndex) {
  beginResetModel();

  m_imgs.erase(m_imgs.begin() + locIndex);

  endResetModel();
}

void ImageModel::recurseImg(const QString &folderUrl, const int imgWidth, const int imgHeight) {
  beginResetModel();

  if (!folderUrl.size()) return;

  auto folderPath = folderUrl.toStdString();

  std::vector<cv::String> imgPaths;
  cv::glob(folderPath, imgPaths);

  m_imgs.clear();
  for (auto &path : imgPaths) {
    auto stdPath = static_cast<std::string>(path);
    //size_t index = stdPath.find_last_of("\\");
    //stdPath.replace(index, 1, "/");

    cv::Mat img = cv::imread(stdPath, 0);
    const int miniNums = img.cols > img.rows ? img.rows : img.cols;
    if(1 == miniNums) {
      cv::Mat imgExpand = cv::Mat(imgHeight, imgWidth, CV_8UC1, cv::Scalar(0));
      if(img.cols > img.rows) {
          for (size_t i = 0; i < imgExpand.rows; ++i) {
              for (size_t j = 0; j < imgExpand.cols; ++j) {
                  imgExpand.ptr<uchar>(i)[j] = img.ptr<uchar>(0)[j];
              }
          }
      }
      else {
          for (size_t i = 0; i < imgExpand.rows; ++i) {
              for (size_t j = 0; j < imgExpand.cols; ++j) {
                  imgExpand.ptr<uchar>(i)[j] = img.ptr<uchar>(i)[0];
              }
          }
      }

      std::string pathWrite = stdPath.substr(0, stdPath.size() - 4) + "_exp.bmp";
      cv::imwrite(pathWrite , imgExpand);
      
      QString path = QFileInfo(QString::fromStdString(pathWrite)).absoluteFilePath();
      m_imgs.push_back(path);
    }
    else {
      QString path = QFileInfo(QString::fromStdString(stdPath)).absoluteFilePath();
      m_imgs.push_back(path);
    }
  }

  endResetModel();
}

QHash<int, QByteArray> ImageModel::roleNames() const { return m_roleNames; }
