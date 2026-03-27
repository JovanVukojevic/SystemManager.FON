export interface ZvanjeRequest {
  naziv: string;
}

export interface ZvanjeResponse {
  idZvanje: number;
  naziv: string;
}

export interface PredmetRequest {
  naziv: string;
  espb: number;
}

export interface PredmetResponse {
  idPredmet: number;
  naziv: string;
  espb: number;
}

export interface NastavnikRequest {
  ime: string;
  idZvanje: number;
}

export interface NastavnikResponse {
  idNastavnik: number;
  ime: string;
  zvanje: ZvanjeResponse;
}

export interface StudentRequest {
  brojIndeksa: string;
  ime: string;
  datumRodjenja: string;
  semestar: string;
}

export interface StudentResponse {
  brojIndeksa: string;
  ime: string;
  datumRodjenja: string;
  semestar: string;
  starost: number;
  prosecnaOcena: number;
}

export interface IspitRequest {
  brojIndeksa: string;
  idPredmet: number;
  idNastavnik: number;
  ocena: number;
  datumPolaganja: string;
}

export interface IspitResponse {
  idIspit: number;
  ocena: number;
  datumPolaganja: string;
  student: StudentResponse;
  predmet: PredmetResponse;
  nastavnik: NastavnikResponse;
}
