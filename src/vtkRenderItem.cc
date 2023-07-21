#include "vtkRenderItem.h"

#include <vtkPointPicker.h>
#include <vtkCommand.h>
#include <vtkRendererCollection.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkRenderWindow.h>
VTKRenderItem::VTKRenderItem() {
    
}

void VTKRenderItem::sync() {
    while(!__commandQueue.empty()){
            std::function<void()> command = std::move( this->__commandQueue.front() );
            this->__commandQueue.pop();
            command();
        }

    QQuickVTKRenderItem::sync();
}
