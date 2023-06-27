#include "vtkProcessEngine.h"
#include "vtkCusInteractorStyleRubberBandPick.h"

#include <vtkPolyData.h>
#include <vtkPoints.h>
#include <vtkCellArray.h>
#include <vtkPolyLine.h>
#include <vtkPolyDataMapper.h>
#include <vtkConeSource.h>
#include <vtkAxesActor.h>
#include <vtkCubeSource.h>
#include <vtkBoxRepresentation.h>
#include <vtkCallbackCommand.h>
#include <vtkCaptionActor2D.h>
#include <vtkTextProperty.h>
#include <vtkTextActor.h>
#include <vtkProperty.h>
#include <vtkBox.h>
#include <vtkBoxWidget2.h>
#include <vtkInteractorStyleTrackballCamera.h>
#include <vtkRenderWindow.h>
#include <vtkQWidgetRepresentation.h>
#include <QQuickVTKInteractiveWidget.h>
#include <QQuickVTKInteractorAdapter.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkCamera.h>
#include <vtkLookupTable.h>
#include <vtkFloatArray.h>
#include <vtkPointData.h>
#include <vtkUnStructuredGrid.h>
#include <vtkPolyVertex.h>
#include <vtkDataSetMapper.h>
#include <vtkDataSet.h>
#include <vtkTextProperty.h>
#include <vtkProperty2D.h>
#include <vtkAreaPicker.h>
#include <vtkProp3DCollection.h>
#include <vtkDataSetSurfaceFilter.h>
//#include <vtkSurfaceReconstructionFilter.h>
#include <vtkDelaunay2D.h>
#include <vtkContourFilter.h>
#include <vtkPLYWriter.h>
#include <vtkVertexGlyphFilter.h>
#include <vtkPolyDataNormals.h>

#include <pcl/filters/statistical_outlier_removal.h>
#include <pcl/PolygonMesh.h>
#include <pcl/surface/vtk_smoothing/vtk_utils.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/kdtree/io.h>
#include <pcl/features/normal_3d.h>
#include <pcl/surface/gp3.h>

vtkNew<vtkCusInteractorStyleRubberBandPick> style;
vtkNew<vtkLookupTable> lookup;
vtkNew<vtkLookupTable> lookupPre;

void progressValCallbackFunc(vtkObject* obj,unsigned long eid,void* clientdata,void *calldata) {
    double* progressVal = static_cast<double*>(clientdata);
    *progressVal = *(static_cast<double*>(calldata));
}

void createLine(const double x1, const double y1, const double z1,
                const double x2, const double y2, const double z2,
                vtkSmartPointer<vtkPoints> points, vtkSmartPointer<vtkCellArray> cells)
{
    vtkSmartPointer<vtkPolyLine> line;
    line = vtkSmartPointer<vtkPolyLine>::New();
    line->GetPointIds()->SetNumberOfIds(2);

    vtkIdType id_1, id_2;
    id_1 = points->InsertNextPoint(x1, y1, z1);
    id_2 = points->InsertNextPoint(x2, y2, z2);

    line->GetPointIds()->SetId(0, id_1);
    line->GetPointIds()->SetId(1, id_2);

    cells->InsertNextCell(line);
}

VTKProcessEngine::VTKProcessEngine() {

}

void VTKProcessEngine::init(QQmlApplicationEngine* engine, QString renderItemObjName, QString statusBarItemObjName) {
    __engine = std::move(engine);

    QObject* topLevel = __engine->rootObjects().value(0);
    __quickWindow = qobject_cast<QQuickWindow*>(topLevel);
    __quickWindow->show();

    __renderItem = topLevel->findChild<VTKRenderItem*>(renderItemObjName);
    __renderWindow = __renderItem->renderWindow();
    __renderer = __renderItem->renderer();

    double axesActor_length = 100.0;
    int16_t axesActor_label_font_size = 20;
    __axesActor->SetTotalLength(axesActor_length, axesActor_length, axesActor_length);
    __axesActor->GetXAxisCaptionActor2D()->GetTextActor()->SetTextScaleModeToNone();
    __axesActor->GetYAxisCaptionActor2D()->GetTextActor()->SetTextScaleModeToNone();
    __axesActor->GetZAxisCaptionActor2D()->GetTextActor()->SetTextScaleModeToNone();
    __axesActor->GetXAxisCaptionActor2D()->GetCaptionTextProperty()->SetFontSize(axesActor_label_font_size);
    __axesActor->GetYAxisCaptionActor2D()->GetCaptionTextProperty()->SetFontSize(axesActor_label_font_size);
    __axesActor->GetZAxisCaptionActor2D()->GetCaptionTextProperty()->SetFontSize(axesActor_label_font_size);
    // Platform Grid
    vtkNew<vtkPolyData> platformGrid;
    vtkSmartPointer<vtkPolyDataMapper> platformGridMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    platformGridMapper->SetInputData(platformGrid);

    __gridActor->SetMapper(platformGridMapper);
    __gridActor->GetProperty()->LightingOff();
    __gridActor->GetProperty()->SetColor(0.45, 0.45, 0.45);
    __gridActor->GetProperty()->SetOpacity(1);
    __gridActor->PickableOff();
    double platformWidth = 200.0;
    double platformDepth = 200.0;
    double gridBottomHeight = 0.15;
    uint16_t gridSize = 10;

    // Platform Grid
    vtkSmartPointer<vtkPoints> gridPoints = vtkSmartPointer<vtkPoints>::New();
    vtkSmartPointer<vtkCellArray> gridCells = vtkSmartPointer<vtkCellArray>::New();

    for (int16_t i = -platformWidth / 2; i <= platformWidth / 2; i += gridSize)
    {
        createLine(i, -platformDepth / 2, gridBottomHeight, i, platformDepth / 2, gridBottomHeight, gridPoints, gridCells);
    }

    for (int16_t i = -platformDepth / 2; i <= platformDepth / 2; i += gridSize)
    {
        createLine(-platformWidth / 2, i, gridBottomHeight, platformWidth / 2, i, gridBottomHeight, gridPoints, gridCells);
    }

    platformGrid->SetPoints(gridPoints);
    platformGrid->SetLines(gridCells);

    __renderItem->renderer()->AddActor(__axesActor);
    __renderItem->renderer()->AddActor(__gridActor);

    __renderItem->renderer()->ResetCamera();
    __renderItem->renderer()->SetBackground(24.f / 255.f, 24.f / 255.f, 24.f / 255.f);
    __renderItem->renderer()->SetBackground2(88.f / 255.f, 88.f / 255.f, 88.f / 255.f);
    __renderItem->renderer()->SetGradientBackground(true);

    __statusBar = topLevel->findChild<QObject*>(statusBarItemObjName);
    // Must set default renderer firstly
    style->SetDefaultRenderer(__renderItem->renderer());
    style->bindStatusBar(__statusBar);
    style->bindRenderItem(__renderItem);
    style->bindVtkProcessEngine(this);
    style->bindCloudActor(__cloud);
    vtkNew<vtkAreaPicker> areaPicker;
    __renderItem->renderWindow()->renderWindow()->GetInteractor()->SetPicker(areaPicker);
    __renderItem->renderWindow()->renderWindow()->GetInteractor()->SetInteractorStyle(style);

    vtkNew<vtkAxesActor> axesActor;
    axesActor->SetTotalLength(axesActor_length, axesActor_length, axesActor_length);
    __orientationWidget = vtkSmartPointer<vtkOrientationMarkerWidget>::New();
    __orientationWidget->SetOutlineColor(0.9300, 0.5700, 0.1300);
    __orientationWidget->SetOrientationMarker(axesActor);
    __orientationWidget->SetInteractor(__renderItem->renderWindow()->renderWindow()->GetInteractor());
    __orientationWidget->SetViewport(0, 0, 0.1, 0.2);
    __orientationWidget->SetEnabled(true);
    __orientationWidget->On();
    __orientationWidget->InteractiveOff();

    double camPositionX = -250;
    double camPositionY = -400;
    double camPositionZ = 400;

    __renderItem->renderer()->GetActiveCamera()->SetPosition(camPositionX, camPositionY, camPositionZ);
    __renderItem->renderer()->GetActiveCamera()->SetViewUp(0.0, 0.0, 1.0);
    __renderItem->renderer()->GetActiveCamera()->SetFocalPoint(0.0, 0.0, 0.0);
    __renderItem->renderer()->GetActiveCamera()->SetClippingRange(0.01, 100000);

    __renderItem->update();
}

void VTKProcessEngine::enableAxes(const bool isEnable) {
    __renderItem->pushCommandToQueue([=] {
        if(isEnable) {
            __axesActor->VisibilityOn();
        }
        else {
            __axesActor->VisibilityOff();
        }

        __renderItem->update();
    });
}

void VTKProcessEngine::enableGrid(const bool isEnable) {
    __renderItem->pushCommandToQueue([=] {
        if(isEnable) {
            __gridActor->VisibilityOn();
        }
        else {
            __gridActor->VisibilityOff();
        }

        __renderItem->update();
    });
}

void VTKProcessEngine::enableOriention(const bool isEnable) {
    __renderItem->pushCommandToQueue([=] {
        if(isEnable) {
            __orientationWidget->On();
        }
        else {
            __orientationWidget->Off();
        }

        __renderItem->update();
    });
}

void VTKProcessEngine::renderCloud(const pcl::PointCloud<pcl::PointXYZRGB>& cloud) {
    vtkNew<vtkPoints> points;
    vtkNew<vtkPolyVertex> polyVertex;
    vtkNew<vtkFloatArray> scalars;
    scalars->SetName("colorTable");
    vtkNew<vtkUnstructuredGrid> grid;
    lookup->SetNumberOfTableValues(cloud.points.size());
    polyVertex->GetPointIds()->SetNumberOfIds(cloud.points.size());
    scalars->SetNumberOfTuples(cloud.points.size());
    lookup->Build();

    for (size_t i = 0; i< cloud.points.size(); ++i) {
        vtkIdType pid[1];
        pid[0] =  points->InsertNextPoint(cloud.points[i].x, cloud.points[i].y, cloud.points[i].z);
        lookup->SetTableValue(i, cloud.points[i].r / 255.f, cloud.points[i].g / 255.f, cloud.points[i].b / 255.f, 1);
        polyVertex->GetPointIds()->SetId(i, i);
        scalars->InsertValue(i, i);
    }

    grid->Allocate(1, 1);
    grid->SetPoints(points);
    grid->GetPointData()->SetScalars(scalars);
    grid->InsertNextCell(polyVertex->GetCellType(), polyVertex->GetPointIds());

    vtkNew<vtkDataSetMapper> mapper;
    mapper->SetInputData(grid);
    mapper->SetLookupTable(lookup);
    mapper->ScalarVisibilityOn();
    mapper->SetScalarRange(0, cloud.points.size() - 1);

    __cloud->SetMapper(mapper);
    __cloud->GetProperty()->SetRepresentationToPoints();
    __cloud->GetProperty()->SetPointSize(1);

    vtkNew<vtkLookupTable> zLookUpTable;
    zLookUpTable->SetNumberOfTableValues(10);
    zLookUpTable->SetHueRange(0.67, 0.0);
    zLookUpTable->SetTableRange(__cloud->GetZRange()[0], __cloud->GetZRange()[1]);
    zLookUpTable->Build();

    __scalarBar->SetTitle("Z(mm)");
    __scalarBar->SetLookupTable(zLookUpTable);
    __scalarBar->SetNumberOfLabels(10);
    __scalarBar->DrawAnnotationsOn();
    __scalarBar->GetPositionCoordinate()->SetCoordinateSystemToNormalizedViewport();
    __scalarBar->GetPositionCoordinate()->SetValue(0.93f, 0.02f);
    __scalarBar->SetWidth(0.06);
    __scalarBar->SetHeight(0.6);
    __scalarBar->SetTextPositionToPrecedeScalarBar();
    __scalarBar->GetTitleTextProperty()->SetColor(1, 1, 1);
    __scalarBar->GetTitleTextProperty()->SetFontSize(6);
    __scalarBar->GetLabelTextProperty()->SetColor(1, 1, 1);
    __scalarBar->GetLabelTextProperty()->SetFontSize(6);
    __scalarBar->GetAnnotationTextProperty()->SetColor(1, 1, 1);
    __scalarBar->GetAnnotationTextProperty()->SetFontSize(6);
    //__scalarBar->SetDrawFrame(1);
    //__scalarBar->GetFrameProperty()->SetColor(0, 0, 0);
    //__scalarBar->SetDrawBackground(1);
    //__scalarBar->GetBackgroundProperty()->SetColor(1, 1, 1);

    __renderer->AddActor(__cloud);
    __renderer->AddActor(__mesh);
    __renderer->AddActor(__scalarBar);
    __renderer->ResetCamera();
    __renderer->DrawOn();
    __renderItem->update();
}

void VTKProcessEngine::enableColorBar(const bool isEnable) {
    isEnable ? __scalarBar->VisibilityOn() : __scalarBar->VisibilityOff();
}

void VTKProcessEngine::enableAreaSelected(const bool isEnable) {
    isEnable ? style->StartSelect() : style->stopSelect();
}

void VTKProcessEngine::updateSelectedRec() {
    emit paintRectangle();
}

void VTKProcessEngine::saveCloud(const QString path) {
    if(!__cloud->GetMapper()) {
        return ;
    }

    if(__asyncThread.joinable()) {
        __asyncThread.join();
    }

    __asyncThread = std::thread([&, path] {
        double progressVal;

        std::thread saveThread = std::thread([&] {
            vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
            surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
            surfaceFilter->Update();

            vtkNew<vtkPLYWriter> writer;
            writer->SetFileName(path.toStdString().data());
            writer->SetInputData(surfaceFilter->GetOutput());
            writer->SetLookupTable(lookup);
            writer->SetArrayName("colorTable");
            writer->SetFileTypeToASCII();

            vtkNew<vtkCallbackCommand> progressCommand;
            progressCommand->SetCallback(progressValCallbackFunc);
            progressCommand->SetClientData(&progressVal);
            writer->AddObserver(vtkCommand::ProgressEvent, progressCommand);

            writer->Update();
        });

        while(progressVal < 1) {
            __progressVal = progressVal;
            emit progressValChanged();
            std::this_thread::sleep_for(std::chrono::milliseconds(300));
        }

        __progressVal = 1;
        emit progressValChanged();

        __statusLabelVal = "status: save point cloud finished, save path is[" + path + "]";
        emit statusLabelChanged();

        std::this_thread::sleep_for(std::chrono::milliseconds(2000));

        __statusLabelVal = "status: idel...";
        emit statusLabelChanged();

        if(saveThread.joinable()) {
            saveThread.join();
        }
    });
}

void VTKProcessEngine::clip(const bool isClipInner) {
    if(!__cloud->GetMapper()) {
        cancelClip();
        return;
    }

    if(__asyncThread.joinable()) {
        __asyncThread.join();
    }

    __asyncThread = std::thread([&, isClipInner] {
        double progressVal = 0;
        std::thread clipThread = std::thread([&] {style->clip(isClipInner, progressVal);});

        while(progressVal < 1) {
            __progressVal = progressVal;
            emit progressValChanged();

            std::this_thread::sleep_for(std::chrono::milliseconds(300));
        }

        vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
        surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
        surfaceFilter->Update();

        vtkLookupTable::SafeDownCast(__scalarBar->GetLookupTable())->SetTableRange(surfaceFilter->GetOutput()->GetBounds()[4], surfaceFilter->GetOutput()->GetBounds()[5]);

        __progressVal = 1;
        emit progressValChanged();

        __statusLabelVal = "status: clip finished...";
        emit statusLabelChanged();

        std::this_thread::sleep_for(std::chrono::milliseconds(2000));

        __statusBar->setProperty("labelText", "status: idel...");
        emit statusLabelChanged();

        if(clipThread.joinable()) {
            clipThread.join();
        }
    });
}

void VTKProcessEngine::cancelClip() {
    style->cancelClip();
}

void VTKProcessEngine::enablePointInfo(const bool isEnable) {
    style->enablePointInfoMode(isEnable);
}

void VTKProcessEngine::release() {
    if(__asyncThread.joinable()) {
        __asyncThread.join();
    }
}

void VTKProcessEngine::statisticalOutRemoval(const float stdThreshold, const float meanK) {
    if(!__cloud->GetMapper()) {
        return;
    }

    if(__asyncThread.joinable()) {
        __asyncThread.join();
    }

    __asyncThread = std::thread([&, stdThreshold, meanK] {
            pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZRGB>);
            auto lookupTable = vtkLookupTable::SafeDownCast(__cloud->GetMapper()->GetLookupTable());

            vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
            surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
            surfaceFilter->Update();
            auto points = surfaceFilter->GetOutput()->GetPoints();

            __progressVal = 0.1;
            emit progressValChanged();

            for (size_t i = 0; i < points->GetNumberOfPoints(); ++i) {
                double x = points->GetPoint(i)[0];
                double y = points->GetPoint(i)[1];
                double z = points->GetPoint(i)[2];
                double r = lookupTable->GetTableValue(i)[0] * 255;
                double g = lookupTable->GetTableValue(i)[1] * 255;
                double b = lookupTable->GetTableValue(i)[2] * 255;
                cloud->points.emplace_back(pcl::PointXYZRGB(x, y, z, r, g, b));
            }

            __progressVal = 0.3;
            emit progressValChanged();

            cloud->is_dense = false;
            cloud->width = cloud->points.size();
            cloud->height = 1;

            pcl::StatisticalOutlierRemoval<pcl::PointXYZRGB> filter;
            filter.setStddevMulThresh(stdThreshold);
            filter.setMeanK(meanK);
            filter.setInputCloud(cloud);

            pcl::Indices indicesFiltered;
            filter.filter(indicesFiltered);

            __progressVal = 0.7;
            emit progressValChanged();

            vtkNew<vtkPoints> pointsVertex;
            vtkNew<vtkPolyVertex> polyVertex;
            vtkNew<vtkFloatArray> scalars;
            scalars->SetName("colorTable");
            vtkNew<vtkUnstructuredGrid> grid;
            lookupTable->SetNumberOfTableValues(indicesFiltered.size());
            polyVertex->GetPointIds()->SetNumberOfIds(indicesFiltered.size());
            scalars->SetNumberOfTuples(indicesFiltered.size());
            lookupTable->Build();

            for (size_t i = 0; i< indicesFiltered.size(); ++i) {
                vtkIdType pid[1];
                pid[0] =  pointsVertex->InsertNextPoint(cloud->points[indicesFiltered[i]].x, cloud->points[indicesFiltered[i]].y, cloud->points[indicesFiltered[i]].z);
                lookupTable->SetTableValue(i, cloud->points[indicesFiltered[i]].r / 255.f, cloud->points[indicesFiltered[i]].g / 255.f, cloud->points[indicesFiltered[i]].b / 255.f, 1);
                polyVertex->GetPointIds()->SetId(i, i);
                scalars->InsertValue(i, i);
            }

            __progressVal = 0.95;
            emit progressValChanged();

            grid->Allocate(1, 1);
            grid->SetPoints(pointsVertex);
            grid->GetPointData()->SetScalars(scalars);
            grid->InsertNextCell(polyVertex->GetCellType(), polyVertex->GetPointIds());

            vtkDataSetMapper::SafeDownCast(__cloud->GetMapper())->SetInputData(grid);
            vtkDataSetMapper::SafeDownCast(__cloud->GetMapper())->SetScalarRange(0, indicesFiltered.size() - 1);

            vtkLookupTable::SafeDownCast(__scalarBar->GetLookupTable())->SetTableRange(__cloud->GetZRange()[0], __cloud->GetZRange()[1]);

            __progressVal = 1;
            emit progressValChanged();

            __statusLabelVal = "status: statics removal finished...";
            emit statusLabelChanged();

            std::this_thread::sleep_for(std::chrono::milliseconds(2000));

            __statusLabelVal = "status: idel...";
            emit statusLabelChanged();
    });
}

void VTKProcessEngine::surfaceRestruction() {
    if(!__cloud->GetMapper()) {
        return;
    }

    if(__asyncThread.joinable()) {
        __asyncThread.join();
    }

    __asyncThread = std::thread([&] {
        double progressVal = 0;

        std::thread workThread = std::thread([&] {
            pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);

            vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
            surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
            surfaceFilter->Update();
            auto points = surfaceFilter->GetOutput()->GetPoints();

            progressVal = 0.1;

            for (size_t i = 0; i < points->GetNumberOfPoints(); ++i) {
                double x = points->GetPoint(i)[0];
                double y = points->GetPoint(i)[1];
                double z = points->GetPoint(i)[2];
                cloud->points.emplace_back(pcl::PointXYZ(x, y, z));
            }

            progressVal = 0.3;

            cloud->is_dense = false;
            cloud->width = cloud->points.size();
            cloud->height = 1;

            pcl::NormalEstimation<pcl::PointXYZ, pcl::Normal> normalEstimation;
            pcl::PointCloud<pcl::Normal>::Ptr normals(new pcl::PointCloud<pcl::Normal>);
            pcl::search::KdTree<pcl::PointXYZ>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZ>);
            tree->setInputCloud(cloud);
            normalEstimation.setInputCloud(cloud);
            normalEstimation.setSearchMethod(tree);
            normalEstimation.setKSearch(20);
            normalEstimation.compute(*normals);

            progressVal = 0.5;

            pcl::PointCloud<pcl::PointNormal>::Ptr cloudNormals(new pcl::PointCloud<pcl::PointNormal>);
            pcl::concatenateFields(*cloud, *normals, *cloudNormals);

            pcl::search::KdTree<pcl::PointNormal>::Ptr searchTreeNormals(new pcl::search::KdTree<pcl::PointNormal>);
            searchTreeNormals->setInputCloud(cloudNormals);

            pcl::GreedyProjectionTriangulation<pcl::PointNormal> gp3;
            pcl::PolygonMesh meshPcl;

            gp3.setSearchRadius(20);
            gp3.setMu(2.5f);
            gp3.setMaximumNearestNeighbors(200);
            gp3.setMaximumSurfaceAngle(M_PI / 4);
            gp3.setMinimumAngle(M_PI / 18);
            gp3.setMaximumAngle(2 * M_PI / 3);
            gp3.setNormalConsistency(false);
            gp3.setInputCloud(cloudNormals);
            gp3.setSearchMethod(searchTreeNormals);

            gp3.reconstruct(meshPcl);

            progressVal = 0.9;

            vtkSmartPointer<vtkPolyData> meshVtk;
            pcl::VTKUtils::mesh2vtk(meshPcl, meshVtk);

            vtkNew<vtkPolyDataMapper> meshMapper;
            meshMapper->SetInputData(meshVtk);
            __mesh->SetMapper(meshMapper);
            __mesh->GetProperty()->SetRepresentationToSurface();

            progressVal = 1;
        });

        while(progressVal < 1) {
            __progressVal = progressVal;
            emit progressValChanged();

            std::this_thread::sleep_for(std::chrono::milliseconds(300));
        }

        __progressVal = 1;
        emit progressValChanged();

        __statusLabelVal = "status: mesh finished...";
        emit statusLabelChanged();

        std::this_thread::sleep_for(std::chrono::milliseconds(2000));

        __statusLabelVal = "status: idel....";
        emit statusLabelChanged();

        if(workThread.joinable()) {
            workThread.join();
        }
    });
}

void VTKProcessEngine::colorizeCloud(QColor color) {
    if(!__cloud->GetMapper()) {
        return;
    }

    auto r = color.redF();
    auto g = color.greenF();
    auto b = color.blueF();
    __cloud->GetProperty()->SetColor(r, g, b);

    __cloud->GetMapper()->SetScalarVisibility(false);

    __renderItem->update();
}

void VTKProcessEngine::cancelColorizeCloud() {
    if(!__cloud->GetMapper()) {
        return;
    }

    __cloud->GetMapper()->SetScalarVisibility(true);
    lookup->DeepCopy(lookupPre);

    __renderItem->update();
}

void VTKProcessEngine::jetDepthColorMap() {
    if(!__cloud->GetMapper()) {
        return;
    }

    vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
    surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
    surfaceFilter->Update();

    double zMin = surfaceFilter->GetOutput()->GetBounds()[4];
    double zMax = surfaceFilter->GetOutput()->GetBounds()[5];

    auto points = vtkUnstructuredGrid::SafeDownCast(__cloud->GetMapper()->GetInput())->GetPoints();
    vtkNew<vtkLookupTable> jetMapLookup;
    jetMapLookup->SetHueRange(0.67, 0.0);
    jetMapLookup->SetTableRange(zMin, zMax);
    jetMapLookup->Build();

    lookupPre->DeepCopy(lookup);

    auto scalars = vtkFloatArray::SafeDownCast(vtkUnstructuredGrid::SafeDownCast(vtkDataSetMapper::SafeDownCast(__cloud->GetMapper())->GetInput())->GetPointData()->GetScalars());

    for (size_t i = 0; i < scalars->GetNumberOfTuples(); ++i) {
        double tabColor[3];
        jetMapLookup->GetColor(points->GetPoint(i)[2], tabColor);
        lookup->SetTableValue(scalars->GetValue(i), tabColor[0], tabColor[1], tabColor[2]);
    }

    __cloud->GetMapper()->SetScalarVisibility(true);
    __cloud->GetProperty()->SetRepresentationToPoints();

    __renderItem->update();
}

void VTKProcessEngine::setCameraViewPort(double x, double y, double z, double fx, double fy, double fz, double vx, double vy, double vz) {
    vtkNew<vtkCamera> camera;

    if(__cloud->GetMapper()) {
        vtkNew<vtkDataSetSurfaceFilter> surfaceFilter;
        surfaceFilter->SetInputData(__cloud->GetMapper()->GetInput());
        surfaceFilter->Update();

        double bounds[6], center[3];
        surfaceFilter->GetOutput()->GetBounds(bounds);
        surfaceFilter->GetOutput()->GetCenter(center);

        if(x != 0) {
            x < 0 ? camera->SetPosition(bounds[0] + x, center[1], center[2]) : camera->SetPosition(bounds[1] + x, center[1], center[2]);
            x < 0 ? camera->SetFocalPoint(bounds[0] + x + 100, center[1], center[2]) : camera->SetFocalPoint(bounds[1] + x - 100, center[1], center[2]);
        }
        else if(y != 0) {
            y < 0 ? camera->SetPosition(center[0], bounds[2] + y, center[2]) : camera->SetPosition(center[0], bounds[3] + y, center[2]);
            y < 0 ? camera->SetFocalPoint(center[0], bounds[2] + y + 100, center[2]) : camera->SetFocalPoint(center[0], bounds[3] + y - 100, center[2]);
        }
        else if(z != 0) {
            z < 0 ? camera->SetPosition(center[0], center[1], bounds[4] + z) : camera->SetPosition(center[0], center[1], bounds[5] + z);
            z < 0 ? camera->SetFocalPoint(center[0], center[1], bounds[4] + z + 100) : camera->SetFocalPoint(center[0], center[1], bounds[5] + z - 100);
        }
    }
    else {
        camera->SetFocalPoint(fx, fy, fz);
        camera->SetPosition(x, y, z);
    }

    camera->SetViewUp(vx, vy, vz);
    __renderer->SetActiveCamera(camera);

    __renderItem->update();
}

void VTKProcessEngine::getCameraViewPort(double& x, double& y, double& z, double& fx, double& fy, double& fz, double& vx, double& vy, double& vz) {
   auto camera = __renderer->GetActiveCamera();

   camera->GetViewUp(vx, vy, vz);

   camera->GetPosition(x, y, z);

   camera->GetFocalPoint(fx, fy, fz);
}

void VTKProcessEngine::enableMesh(const bool isEnable) {
    if(!__mesh->GetMapper()) {
        return;
    }

    isEnable ? __mesh->VisibilityOn() : __mesh->VisibilityOff();

    __renderItem->update();
}

void VTKProcessEngine::enableCloud(const bool isEnable) {
    if(!__cloud->GetMapper()) {
        return;
    }

    isEnable ? __cloud->VisibilityOn() : __cloud->VisibilityOff();

    __renderItem->update();
}
