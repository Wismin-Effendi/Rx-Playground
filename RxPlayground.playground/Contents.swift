import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


import RxSwift

example(of: "map") {
    
    Observable.of(1,2,3,4,5)
        .map { $0 * $0 }
        .subscribe(onNext: {
            print($0)
        })
        .dispose()
}

example(of: "flatMap and flatMapLatest") {
    
    struct Patient {
        let name_weight: Variable<(String,Int)>
    }
    
    let disposeBag = DisposeBag()
    
    let wally = Patient(name_weight: Variable(("Wally",140)))
    
    let lolly = Patient(name_weight: Variable(("Lolly",120)))
    
    let currentPatient = Variable(wally)
    
    currentPatient.asObservable()
       // .flatMap { $0.name_weight.asObservable() }
        .flatMapLatest { $0.name_weight.asObservable() }
        .subscribe(onNext: { print("Current patient name and weight: \($0)") })
        .disposed(by: disposeBag)
    
    currentPatient.value.name_weight.value = ("Wally",145)
    
    wally.name_weight.value = ("Wally",148)
    
    currentPatient.value = lolly
    
    wally.name_weight.value = ("Wally",150)
    
}

func showDebugging() {
    
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .publish()
    
    interval
        .debug("1st")
        .subscribe()
    
    delay(2) {
        _ = interval.connect()
    }
    
    delay(4) {
        interval
            .debug("2nd")
            .subscribe()
            .dispose()
    }
    
    delay(3) {
        _ = interval
                .debug("3rd")
                .subscribe()
    }
}

// showDebugging()
