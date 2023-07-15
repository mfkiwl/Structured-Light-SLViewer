#include "CalibrationMaster/include/cameraModel.h"

CameraModel::CameraModel(QObject *parent) : QAbstractListModel(parent) {
  m_roleNames.insert(FileName, "FileName");
}

CameraModel::~CameraModel() {}

int CameraModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent);
  return m_imgs.count();
}

QVariant CameraModel::data(const QModelIndex &index, int role) const {
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

void CameraModel::emplace_back(const QString &imgInfo) {
  beginResetModel();

  m_imgs.push_back(imgInfo);

  endResetModel();
}

int CameraModel::erase(const QString &imgInfo) {
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

void CameraModel::erase(int locIndex) {
  beginResetModel();

  m_imgs.erase(m_imgs.begin() + locIndex);

  endResetModel();
}

void CameraModel::recurseImg(const QUrl &folderUrl) {
  beginResetModel();

  if (!folderUrl.isValid()) return;

  auto folderPath = folderUrl.toString().toStdString().substr(
      8, folderUrl.toString().size() - 8);

  std::vector<cv::String> imgPaths;
  cv::glob(folderPath, imgPaths);

  m_imgs.clear();
  for (auto &path : imgPaths) {
    auto stdPath = static_cast<std::string>(path);
    size_t index = stdPath.find_last_of("\\");
    stdPath.replace(index, 1, "/");
    m_imgs.push_back(QString::fromStdString(stdPath));
  }

  endResetModel();
}

QHash<int, QByteArray> CameraModel::roleNames() const { return m_roleNames; }
