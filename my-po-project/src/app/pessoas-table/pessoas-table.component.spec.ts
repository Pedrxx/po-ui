import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PessoasTableComponent } from './pessoas-table.component';

describe('PessoasTableComponent', () => {
  let component: PessoasTableComponent;
  let fixture: ComponentFixture<PessoasTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PessoasTableComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PessoasTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
